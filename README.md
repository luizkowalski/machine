# Kowa's Dotfiles

## Setup

Install [mise](https://mise.jdx.dev/installing-mise.html), then clone and bootstrap the appropriate profile:

```sh
git clone https://github.com/luizkowalski/dotfiles ~/Projects/dotfiles
cd ~/Projects/dotfiles
mise trust
mise -E home bootstrap # or: mise -E work bootstrap
```

Use `home` or `work` consistently in the commands below.

## Day-to-day use

Inspect the current machine without changing it:

```sh
mise -E home bootstrap status             # show all managed state
mise -E home bootstrap status --missing   # exit 1 when anything has drifted
mise -E home bootstrap plan               # show the changes mise would make
mise -E home bootstrap plan --detailed-exitcode
```

`plan --detailed-exitcode` exits 0 when the machine is in sync, 2 when it
would make changes, and 1 on errors.

Converge the declarative state without running the custom macOS task:

```sh
mise -E home bootstrap --skip task
```

Run the complete setup, including the macOS task:

```sh
mise -E home bootstrap
```

Refresh package metadata and managed repositories while converging:

```sh
mise -E home bootstrap --update
```

Inspect or apply one part at a time:

```sh
mise -E home bootstrap packages status
mise -E home bootstrap repos status
mise -E home bootstrap dotfiles status
mise -E home bootstrap macos defaults status

mise -E home bootstrap packages apply
mise -E home bootstrap repos apply
mise -E home bootstrap dotfiles apply
mise -E home bootstrap macos defaults apply
```

Add and immediately install Homebrew packages from the repository root:

```sh
mise bootstrap packages use brew:jq
mise bootstrap packages use brew-cask:firefox
mise bootstrap packages use brew:jq brew-cask:firefox # multiple packages
```

The command writes the packages to the shared `mise.toml`. Homebrew versions
such as `postgresql@17` are part of the package name:

```sh
mise bootstrap packages use brew:postgresql@17
```

Preview without changing the config or installing anything:

```sh
mise bootstrap packages use --dry-run brew:jq
```

Preview an individual part by adding `--dry-run` to its `apply` command.
For example:

```sh
mise -E home bootstrap dotfiles apply --dry-run --verbose
mise -E home bootstrap macos defaults apply --dry-run
```

Check for and install newer versions of mise-managed development tools:

```sh
mise -E home upgrade --dry-run
mise -E home upgrade
```

### Existing machines

Mise will not take over casks already owned by Homebrew or update dirty managed repositories. Clean those repositories and uninstall only the existing casks you want mise to own before the first bootstrap. Preview the migration first; real files left by the old Stow setup may require the one-time force flag:

```sh
mise -E home bootstrap --dry-run --force-dotfiles
mise -E home bootstrap --force-dotfiles
```

## Optional setup

SSH keys require an installed and unlocked Bitwarden CLI:

```sh
mise run ssh
```

Build and install the bulb controller with:

```sh
mise run bulb
```

Mise's direct Homebrew installer cannot currently install these casks:

- `st0012/cctop/cctop` and `steipete/tap/codexbar` do not publish tap API metadata.
- `macfuse` and `ngrok` use unsupported cask postflight operations.

Install any of them manually if needed. Mise also does not implement
`brew services`; with Homebrew available, start the optional services with:

```sh
brew services start libvirt
brew services start valkey
```
