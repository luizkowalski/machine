# Simple tmux configuration

## Goal

Add a beginner-friendly tmux setup that preserves the standard `Ctrl-b`
prefix and creates the preferred three-pane coding workspace with `tcode`.

## Configuration

Keep the configuration in `shell/.config/tmux/tmux.conf` so the existing
`shell` Stow package installs it.

Use tmux's built-in features only:

- enable mouse selection, resizing, and scrolling;
- retain the standard key bindings;
- add `Ctrl-b |` and `Ctrl-b -` splits that inherit the active pane's path;
- add `Ctrl-b h/j/k/l` pane navigation;
- increase scrollback history;
- style the status bar and pane borders with a restrained TokyoNight palette
  matching Ghostty.

## Workspace launcher

Add a `tcode` function to `shell/.functions`. From the current directory it
will create and attach to a session named `code`, with:

- a shell in the left pane for the coding agent;
- a shell in the upper-right pane;
- lazygit in the lower-right pane.

If that session already exists, `tcode` will attach to it instead of creating
a duplicate. Exiting lazygit may close only its pane; the session remains.

## Dependencies and scope

Use the existing tmux and lazygit Homebrew packages. Do not add TPM, themes,
plugins, or a separate session manager. Reconsider `tmux-resurrect` only if
restoring sessions after a reboot becomes necessary.

## Verification

- Load the config with a temporary tmux server and confirm it parses.
- Run a shell syntax check on `shell/.functions`.
- Exercise `tcode` against a temporary tmux server to confirm the three-pane
  layout and attach-existing behavior without disturbing active sessions.
