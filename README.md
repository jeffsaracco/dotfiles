# Jeff Saracco's dotfiles

Dotbot manages links, vim-plug manages Neovim plugins, and Git submodules
provide Dotbot, TPM, and the custom Zsh plugins.

Supported platforms:

- Apple Silicon macOS
- Current Ubuntu and Debian releases
- GitHub Codespaces based on Ubuntu or Debian

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

- `desktop` adds Alacritty and its configuration.
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

## Safety

The bootstrap does not clean `$HOME`, force-overwrite files, or replace an
existing non-dotfiles configuration. If a managed destination already exists,
Dotbot stops so it can be reviewed and moved manually.

The installer does not change the login shell. To opt in after installation:

```sh
chsh -s "$(command -v zsh)"
```

## Local Configuration

The installer creates `~/.gitconfig.local` and `~/.zshrc.local` with mode 600
when they are absent. It never overwrites them. Put identity, signing settings,
private environment variables, and machine-specific paths there.

Examples are tracked at:

- `home/git/gitconfig.local.example`
- `home/zsh/zshrc.local.example`

## Services

Start only services needed on a particular machine. For example:

```sh
brew services start redis
sudo systemctl enable --now redis-server
```

## Tmux Plugins

Inside tmux, install or update TPM plugins with `<prefix> + I`.
