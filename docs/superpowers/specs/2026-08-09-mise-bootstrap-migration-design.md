# Mise Bootstrap Migration Design

## Goal

Replace GNU Stow, the Brewfile workflow, and machine-setup Make targets with
`mise bootstrap` while preserving the home/work profiles and existing dotfiles.
After cloning the repository and installing mise, either profile must be
provisioned with:

```sh
mise trust
mise -E home bootstrap
# or
mise -E work bootstrap
```

## Configuration

`mise.toml` is the shared source of truth. It declares bootstrap packages,
global tools, repositories, common dotfiles, the login shell, macOS defaults,
and the small set of tasks that mise cannot express declaratively.

`mise.home.toml` and `mise.work.toml` override only the source of
`~/.gitconfig.local` and `~/.zshrc.local`. The package set initially remains the
same for both profiles so the work profile can be reduced separately later.

Bootstrap manages the repository's mise configuration at
`~/.config/mise/config.toml`. This keeps the declared tools global while still
allowing nearer project configurations to override them.

## Packages and tools

Convert Homebrew formulae to `brew:` packages, casks to `brew-cask:` packages,
and Mac App Store applications to `mas:<id>` packages. Declare required tap
sources under `[bootstrap.brew.taps]`.

Move Node 24, Go, Rust, Ruby, Python 3.14, Bun, and Terraform to `[tools]`.
Keep shared libraries, system utilities, and GUI applications in
`[bootstrap.packages]`. Remove Stow and duplicate runtime formulae.

Mise does not implement `brew services`. Bootstrap installs `libvirt` and
`valkey`; the README documents their optional `brew services start` commands.

## Dotfiles and repositories

Keep the current repository layout and replace each Stow package with explicit
`[dotfiles]` entries. Use ordinary symlinks for individual files and
`symlink-each` for shared directories, preserving unmanaged neighboring files
such as OpenCode's generated `node_modules`.

Declare Oh My Zsh and its four custom plugins in `[bootstrap.repos]`. The
existing Neovim configuration already bootstraps its plugins, so remove the
destructive NvChad installer.

Remove the stale hard-coded Node installation path from `.zshrc` and express
the Antigravity path relative to `$HOME`.

## macOS configuration

Translate every supported entry in `scripts/mac` to the friendly
`[bootstrap.macos.*]` sections or typed raw `[bootstrap.macos.defaults]`
entries.

Keep one idempotent task for the three settings the schema cannot express:

- host-scoped `AppleFontSmoothing` because current-host defaults are unsupported;
- `AppleLanguages` because array values are unsupported;
- `StartupMute` because NVRAM is not a defaults domain.

The task comments explain each limitation and changes only values that differ.
Mise's normal follow-up reminder covers restarting Finder and Dock.

## Explicit tasks

SSH provisioning remains an explicit `mise run ssh` operation because it
depends on an installed, unlocked Bitwarden CLI that may be unavailable on a
managed work Mac. The bulb utility remains an explicit build/install task.
Neither task blocks normal bootstrap.

## Legacy removal

After equivalent mise configuration exists, remove `Brewfile`, the root
`Makefile`, `scripts/stow-force`, `scripts/install_homebrew`, and
`scripts/install_nvchad`. Retain only scripts still invoked by explicit mise
tasks or whose logic cannot be represented directly.

## Fresh-machine flow

The user clones this repository and installs mise normally. From the checkout,
they trust the configuration and run the chosen profile's bootstrap command.
There is no seed configuration, self-cloning flow, or custom mise installer.

## Failure behavior and verification

Mise remains the package installer even when a tap or cask is unsupported; the
migration does not silently invoke Homebrew as a fallback. Such limitations
must be reported and documented as manual follow-up.

Verify both profiles in the isolated worktree with:

- mise configuration parsing and task discovery;
- bootstrap status and plan commands;
- full bootstrap dry runs;
- shell syntax checks for retained scripts;
- checks that every former Stow target and Brewfile item has a mise owner;
- a clean `git diff --check`.

Verification must not apply packages, defaults, dotfiles, or services to the
current machine.
