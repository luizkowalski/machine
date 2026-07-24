# Simple tmux Configuration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a native TokyoNight-styled tmux configuration and a `tcode`
launcher for the preferred three-pane workspace.

**Architecture:** tmux reads one configuration file from the existing `shell`
Stow package. The existing shell functions file provides one launcher that
creates the `code` session once and attaches or switches to it thereafter.

**Tech Stack:** tmux 3.7b, zsh, lazygit, GNU Stow

## Global Constraints

- Keep tmux's standard `Ctrl-b` prefix and default bindings.
- Use only built-in tmux features and existing Homebrew packages.
- Do not add TPM, plugins, themes, or a separate session manager.
- Use `tcode` for the launcher; do not shadow VS Code's `code` command.

---

### Task 1: Add the tmux configuration and workspace launcher

**Files:**
- Create: `shell/.config/tmux/tmux.conf`
- Modify: `shell/.functions`

**Interfaces:**
- Consumes: tmux, lazygit, `$PWD`, and the existing `shell` Stow package.
- Produces: `tcode()` and tmux bindings for `|`, `-`, `h`, `j`, `k`, and `l`.

- [ ] **Step 1: Verify the files do not already provide these interfaces**

Run:

```sh
test ! -e shell/.config/tmux/tmux.conf
! rg -n '^function tcode\\(' shell/.functions
```

Expected: exit status 0.

- [ ] **Step 2: Add the native tmux configuration**

Create `shell/.config/tmux/tmux.conf` with:

```tmux
set -g mouse on
set -g history-limit 50000

bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

set -g status-style "bg=#1a1b26,fg=#a9b1d6"
set -g status-left "#[bold,fg=#7aa2f7] #S "
set -g status-right "#[fg=#565f89]%H:%M "
setw -g window-status-format " #I:#W "
setw -g window-status-current-format "#[bold,fg=#1a1b26,bg=#7aa2f7] #I:#W "
set -g pane-border-style "fg=#3b4261"
set -g pane-active-border-style "fg=#7aa2f7"
```

- [ ] **Step 3: Add the `tcode` launcher**

Append this function to `shell/.functions`:

```zsh
function tcode() {
  local connect=attach-session
  [[ -n "$TMUX" ]] && connect=switch-client

  if ! tmux has-session -t code 2>/dev/null; then
    tmux new-session -d -s code -c "$PWD" \; \
      split-window -h -c "$PWD" \; \
      split-window -v -c "$PWD" lazygit \; \
      select-pane -t 0 || return
  fi

  tmux "$connect" -t code
}
```

- [ ] **Step 4: Verify parsing and behavior**

Run:

```sh
zsh -n shell/.functions
tmux -L codex-tmux-config -f shell/.config/tmux/tmux.conf \
  start-server \; show-options -g mouse
tmux -L codex-tmux-config kill-server
zsh -c '
  source shell/.functions
  function tmux() {
    if [[ $1 == attach-session || $1 == switch-client ]]; then
      return
    fi
    command tmux -L codex-tcode-test "$@"
  }
  tcode
  [[ $(command tmux -L codex-tcode-test list-panes -t code:0 | wc -l) == 3 ]]
  tcode
  [[ $(command tmux -L codex-tcode-test list-sessions -F "#{session_name}" | wc -l) == 1 ]]
  command tmux -L codex-tcode-test kill-server
'
git diff --check
```

Expected: all commands exit 0; `show-options` prints `mouse on`; the temporary
`code` session has three panes and remains a single session after a second
`tcode` call.

- [ ] **Step 5: Commit**

```sh
git add shell/.config/tmux/tmux.conf shell/.functions \
  docs/superpowers/plans/2026-07-24-tmux-config.md
git commit -m "feat(tmux): Add coding workspace"
```
