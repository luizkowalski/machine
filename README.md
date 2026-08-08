# Kowa's Dotfiles

## Setup

Install [mise](https://mise.jdx.dev/installing-mise.html), then clone and
bootstrap the appropriate profile:

```sh
git clone https://github.com/luizkowalski/dotfiles ~/Projects/dotfiles
cd ~/Projects/dotfiles
mise trust
mise -E home bootstrap # or: mise -E work bootstrap
```

Run `mise -E home bootstrap --update` (or the work equivalent) to update
managed repositories as well as converge the machine.

### Existing machines

Mise will not take over casks already owned by Homebrew or update dirty managed
repositories. Clean those repositories and uninstall only the existing casks
you want mise to own before the first bootstrap. Preview the migration first;
real files left by the old Stow setup may require the one-time force flag:

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
- `sqlitestudio` is absent from the Homebrew cask API.

Install any of them manually if needed. Mise also does not implement
`brew services`; with Homebrew available, start the optional services with:

```sh
brew services start libvirt
brew services start valkey
```
