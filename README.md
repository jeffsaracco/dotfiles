# Jeff Saracco's dotfiles

Dotbot manages links, vim-plug manages Neovim plugins, and Git submodules
provide Dotbot, Oh My Zsh, TPM, and the custom Zsh plugins.

Supported platforms:

- Apple Silicon macOS
- Current Ubuntu and Debian releases
- GitHub Codespaces based on Ubuntu or Debian

Linux installs the checksum-verified Neovim 0.12.5 release under
`~/.local/lib`; macOS uses Homebrew's current stable Neovim.

## Install

Clone over HTTPS so a new machine does not require SSH credentials before
bootstrap:

```sh
git clone https://github.com/jeffsaracco/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install
```

With no arguments, `install` applies the safe CLI base. Profiles are additive:

```sh
./install desktop
./install services
./install desktop services
```

- `desktop` adds Alacritty, AeroSpace, a Nerd Font, and their configuration.
- `services` installs database, cache, and web-server packages without
  explicitly enabling or starting them.

On Ubuntu or Debian, authorize sudo before running the installer:

```sh
sudo -v
./install
```

On macOS, install Xcode Command Line Tools first:

```sh
xcode-select --install
```

The bootstrap explicitly updates Homebrew before evaluating the Brewfiles so
an existing installation recognizes the host macOS release.

## Safety

The bootstrap does not clean `$HOME` or delete existing configuration. If a
managed link destination already exists as a regular file or directory, it is
moved to `<path>.backup.<timestamp>` before Dotbot links the repository copy.
Review the backup and merge anything worth keeping into the repository.

A legacy `~/.oh-my-zsh` checkout created by an older version of this repository
is moved to a timestamped backup the same way before the pinned Oh My Zsh
submodule is linked.

The installer does not change the login shell. To opt in after installation:

```sh
chsh -s "$(command -v zsh)"
```

## Local Configuration

The installer creates `~/.gitconfig.local` and `~/.zshrc.local` with mode 600
when they are absent. It never overwrites existing values. The Git file is
seeded with this repository owner's identity and the macOS credential helper.
Put signing settings, private environment variables, and machine-specific
paths in the local files.

Examples are tracked at:

- `home/git/gitconfig.local.example`
- `home/zsh/zshrc.local.example`

## Syncing Between Machines

`dotsync` (in `bin/`) commits changes to tracked files, rebases onto the
remote, pushes, and re-runs Dotbot when `install.conf.json` changed. On macOS,
`install` loads a launchd agent that runs it at login and every 15 minutes
(`script/install-dotsync-agent.sh`; log at `~/Library/Logs/dotsync.log`).

Because this repository is public and the working tree is live config,
`dotsync` never commits untracked files or submodule pointer moves. Add new
files and bump submodules yourself. On a conflict it aborts the rebase, keeps
the local commit, and posts a notification; resolve it with
`git pull --autostash`.

Some apps rewrite their JSON config with per-machine values. `.gitattributes`
lists those keys (`volatile-keys`). The `json-volatile` filter in
`home/git/gitconfig` keeps them out of Git and restores each machine's own
values on checkout. `git status` can flag such a file as modified until the
next `git add`, even when only those keys changed; plain `git pull` then
refuses, so use `git pull --autostash`.

## Services

Start only services needed on a particular machine. For example:

```sh
brew services start redis
sudo systemctl enable --now redis-server
```

## Tmux Plugins

Inside tmux, install or update TPM plugins with `<prefix> + I`.
