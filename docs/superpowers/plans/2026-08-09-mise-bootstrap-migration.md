# Mise Bootstrap Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace Stow, Brewfile, and Make-based workstation setup with profile-aware `mise bootstrap` configuration.

**Architecture:** A root `mise.toml` owns shared packages, global tools, repositories, dotfiles, macOS preferences, and tasks. `mise.home.toml` and `mise.work.toml` provide only the two identity-specific dotfile mappings. Existing scripts survive only when mise cannot represent their behavior declaratively.

**Tech Stack:** mise 2026.8.3 bootstrap configuration, TOML, POSIX shell, Homebrew package metadata, macOS `defaults` and `nvram`.

## Global Constraints

- Work only in `/Users/luiz/Projects/dotfiles-worktrees/mise-bootstrap` on `feat/mise-bootstrap`.
- Normal setup is `mise trust` followed by `mise -E home bootstrap` or `mise -E work bootstrap`.
- Do not add a seed config, self-cloning flow, custom mise installer, Stow fallback, or Brewfile wrapper.
- Keep tools global while allowing directory-local mise configurations to override them.
- Use native mise bootstrap sections wherever supported; use tasks only for documented schema gaps.
- Do not apply packages, defaults, dotfiles, repositories, or services to the current machine during verification.
- Keep the initial package set identical for home and work.
- SSH and bulb installation remain explicit tasks and never block normal bootstrap.

---

### Task 1: Declare packages and global tools

**Files:**
- Create: `mise.toml`
- Read then remove in Task 4: `Brewfile`

**Interfaces:**
- Consumes: the complete formula, cask, tap, and MAS inventory in `Brewfile`; global tool settings from `~/.config/mise/config.toml` recorded in the design audit.
- Produces: a valid root mise config with `[tools]`, `[settings]`, `[bootstrap.packages]`, `[bootstrap.brew.taps]`, and `[bootstrap.user]`.

- [ ] **Step 1: Record the inventory assertions**

Run:

```sh
rg -c '^brew ' Brewfile
rg -c '^cask ' Brewfile
rg -c '^mas ' Brewfile
```

Expected before migration: `101` formulae, `28` casks, and `6` MAS apps. Recount rather than weakening the check if the source changed after this plan was written.

- [ ] **Step 2: Create the minimal shared config**

Create `mise.toml` with:

```toml
[tools]
bun = "latest"
go = "latest"
node = "24"
python = "3.14"
ruby = "latest"
rust = "latest"
terraform = "latest"

[settings]
experimental = true
idiomatic_version_file_enable_tools = ["ruby", "bun"]

[settings.ruby]
compile = false

[settings.python]
compile = false

[bootstrap.user]
login_shell = "/bin/zsh"
```

Add every Brewfile formula as `"brew:<canonical-name>" = "latest"`, except `clippy`, `go`, `mise`, `node@24`, `rust`, `rustup`, and `hashicorp/tap/terraform`, which are replaced by `[tools]`. Add every cask as `"brew-cask:<canonical-name>" = "latest"` and every MAS ID as `"mas:<numeric-id>" = "latest"`. Declare GitHub tap URLs only for third-party packages that remain referenced.

- [ ] **Step 3: Verify parsing without installing**

Run:

```sh
mise trust mise.toml
mise config
mise tasks ls
mise bootstrap packages status --json >/dev/null
```

Expected: all commands exit `0`; no package apply command runs.

- [ ] **Step 4: Verify removed runtime duplication**

Run:

```sh
rg 'brew:(clippy|go|mise|node@24|rust|rustup|hashicorp/tap/terraform)' mise.toml
```

Expected: no matches.

- [ ] **Step 5: Commit**

```sh
git add mise.toml
git commit -m "feat: Declare workstation packages and tools in mise"
```

### Task 2: Replace Stow with profile-aware dotfiles and repositories

**Files:**
- Modify: `mise.toml`
- Create: `mise.home.toml`
- Create: `mise.work.toml`
- Modify: `shell/.zshrc`

**Interfaces:**
- Consumes: all targets in the `shell`, `nvim`, `cursor`, `ghostty`, `lazygit`, `opencode`, and `atuin` Stow packages.
- Produces: common `[dotfiles]` and `[bootstrap.repos]` declarations plus home/work overrides for `~/.gitconfig.local` and `~/.zshrc.local`.

- [ ] **Step 1: Add common dotfile mappings**

Add explicit source mappings for every tracked Stow target. Use `mode = "symlink"` for individual files. Use `mode = "symlink-each"` for the `tmux`, `zellij`, `nvim`, `ghostty`, `lazygit`, `opencode`, and `atuin` directories so unmanaged neighbors survive. Manage `mise.toml` at `~/.config/mise/config.toml` with `mode = "copy"` so the first migration does not require `--force-dotfiles`.

- [ ] **Step 2: Add profile overlays**

Create `mise.home.toml` mapping the two local targets to `shell-home`, and create `mise.work.toml` mapping them to `shell-work`:

```toml
[dotfiles]
"~/.gitconfig.local" = "shell-home/.gitconfig.local"
"~/.zshrc.local" = "shell-home/.zshrc.local"
```

Use the corresponding `shell-work` sources in `mise.work.toml`.

- [ ] **Step 3: Declare shell repositories**

Add repository entries for Oh My Zsh and these plugins using their existing HTTPS URLs:

```text
~/.oh-my-zsh
~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
~/.oh-my-zsh/custom/plugins/zsh-autocomplete
~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
~/.oh-my-zsh/custom/plugins/fzf-tab
```

Do not pin refs. Normal apply clones missing repositories; `mise bootstrap --update` performs explicit updates.

- [ ] **Step 4: Remove non-portable shell paths**

Delete the hard-coded `/Users/luiz.kowalski/.local/share/mise/installs/node/24.17.0/bin` export. Change the Antigravity IDE path from `/Users/luiz/...` to `$HOME/...`.

- [ ] **Step 5: Verify both profiles without applying**

Run:

```sh
mise -E home config
mise -E work config
mise -E home bootstrap dotfiles status --json >/dev/null
mise -E work bootstrap dotfiles status --json >/dev/null
mise bootstrap repos status --json >/dev/null
```

Expected: configs parse, each profile resolves its own local sources, and status commands do not mutate the home directory.

- [ ] **Step 6: Commit**

```sh
git add mise.toml mise.home.toml mise.work.toml shell/.zshrc
git commit -m "feat: Manage dotfiles and shell repositories with mise"
```

### Task 3: Migrate macOS settings and explicit tasks

**Files:**
- Modify: `mise.toml`
- Modify: `scripts/mac`
- Create: `scripts/test_mac`
- Modify: `scripts/install_ssh_keys`

**Interfaces:**
- Consumes: all commands currently in `scripts/mac`, the existing SSH installer, and `scripts/build_bulb.sh`.
- Produces: declarative macOS defaults, an idempotent bootstrap task for unsupported settings, explicit `ssh` and `bulb` tasks, and a runnable shell self-check.

- [ ] **Step 1: Translate supported defaults**

Use friendly Dock, Finder, and keyboard keys where available. Put the remaining boolean, integer, and string preferences under typed raw `[bootstrap.macos.defaults]` entries. Preserve the existing value types, including string-valued Bluetooth entries that currently omit `-int`.

- [ ] **Step 2: Reduce `scripts/mac` to unsupported operations**

Keep only current-host `AppleFontSmoothing`, the `AppleLanguages` array, and NVRAM `StartupMute`. Add comments citing the exact limitation for each operation. Compare the current NVRAM value before invoking `sudo`; do not prompt when it already equals `%01`.

- [ ] **Step 3: Add one runnable check**

Create `scripts/test_mac` with temporary mock `defaults`, `nvram`, and `sudo` executables. Assert that an already-converged run does not call `sudo`, while a differing NVRAM value calls `sudo nvram StartupMute=%01` exactly once.

- [ ] **Step 4: Expose tasks**

Add:

```toml
[tasks.bootstrap]
run = "scripts/mac"

[tasks.ssh]
run = "scripts/install_ssh_keys"

[tasks.bulb]
run = "scripts/build_bulb.sh"
```

Guard the normal bootstrap task to macOS inside `scripts/mac`. Keep SSH and bulb explicit.

- [ ] **Step 5: Fix SSH preflight ordering**

Move the `command -v bw` check before `bw sync`, so a missing Bitwarden CLI produces the intended error instead of a shell command-not-found failure.

- [ ] **Step 6: Run shell checks**

Run:

```sh
bash -n scripts/mac scripts/test_mac scripts/build_bulb.sh
sh -n scripts/install_ssh_keys
scripts/test_mac
shellcheck scripts/mac scripts/test_mac scripts/install_ssh_keys scripts/build_bulb.sh
```

Expected: all commands pass.

- [ ] **Step 7: Commit**

```sh
git add mise.toml scripts/mac scripts/test_mac scripts/install_ssh_keys
git commit -m "feat: Migrate macOS and explicit setup tasks to mise"
```

### Task 4: Remove legacy orchestration and document setup

**Files:**
- Modify: `README.md`
- Delete: `Brewfile`
- Delete: `Makefile`
- Delete: `.stow-local-ignore`
- Delete: `scripts/stow-force`
- Delete: `scripts/install_homebrew`
- Delete: `scripts/install_nvchad`
- Delete: `scripts/install_oh_my_zsh`
- Delete: `scripts/install_zsh_plugins`
- Delete: `scripts/Makefile`

**Interfaces:**
- Consumes: the completed mise configuration and tasks.
- Produces: a mise-only documented setup with no executable legacy path.

- [ ] **Step 1: Rewrite the README**

Document only this primary flow:

```sh
git clone https://github.com/luizkowalski/dotfiles ~/Projects/dotfiles
cd ~/Projects/dotfiles
mise trust
mise -E home bootstrap   # or: mise -E work bootstrap
```

State that mise must be installed before these commands. Document `mise run ssh`, `mise run bulb`, `mise bootstrap --update`, and optional `brew services start libvirt` / `brew services start valkey`. Note that SSH needs an installed and unlocked `bw` CLI.

- [ ] **Step 2: Delete superseded files**

Remove the files listed above. Retain `scripts/mac`, `scripts/test_mac`, `scripts/install_ssh_keys`, `scripts/build_bulb.sh`, `scripts/bulb.go`, and the Go module files.

- [ ] **Step 3: Prove no legacy orchestration remains**

Run:

```sh
rg -n 'stow|brew bundle|make (bootstrap|brew|mac|ssh|zsh|nvim)' -g '!docs/superpowers/**' .
```

Expected: no executable setup instructions or configuration references remain.

- [ ] **Step 4: Commit**

```sh
git add -A
git commit -m "docs: Replace legacy setup with mise bootstrap"
```

### Task 5: Verify the complete migration

**Files:**
- Modify only if verification finds a defect in a file created or changed above.

**Interfaces:**
- Consumes: the complete migration.
- Produces: evidence that both profiles parse and plan without mutating the current machine.

- [ ] **Step 1: Validate repository hygiene**

Run:

```sh
git diff --check master...HEAD
git status --short
```

Expected: no whitespace errors and no uncommitted files.

- [ ] **Step 2: Validate shell logic**

Run:

```sh
scripts/test_mac
shellcheck scripts/mac scripts/test_mac scripts/install_ssh_keys scripts/build_bulb.sh
```

Expected: all checks pass.

- [ ] **Step 3: Validate both resolved configs**

Run:

```sh
mise -E home config
mise -E work config
mise -E home tasks ls
mise -E work tasks ls
```

Expected: both profiles load; `bootstrap`, `ssh`, and `bulb` tasks are present.

- [ ] **Step 4: Validate declarative state and plans**

Run:

```sh
mise -E home bootstrap status
mise -E work bootstrap status
mise -E home bootstrap plan
mise -E work bootstrap plan
mise -E home bootstrap --dry-run
mise -E work bootstrap --dry-run
```

Expected: commands may report missing or differing resources but must parse all declarations and print plans without applying changes. Record any unsupported tap or cask as a README manual follow-up rather than adding a Homebrew fallback.

- [ ] **Step 5: Verify inventory ownership**

Compare the parent commit's `Brewfile` and Stow target list against `mise.toml`. Every retained package, cask, MAS ID, and target must have exactly one mise owner; approved runtime replacements count as owned by `[tools]`.

- [ ] **Step 6: Commit verification fixes if necessary**

```sh
git add -A
git commit -m "fix: Resolve mise bootstrap verification issues"
```

Skip this commit when verification required no changes.
