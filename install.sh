#!/usr/bin/env zsh

ln -sf ~/dotfiles/home/zsh/zshrc ~/.zshrc
ln -sf ~/dotfiles/home/git/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/home/git/gitignore_global ~/.gitignore_global
ln -sf ~/dotfiles/home/config/nvim ~/.config/nvim
ln -sf ~/dotfiles/home/config/alacritty ~/.config/alacritty
ln -sf ~/dotfiles/home/tmux/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/home/atom ~/.atom

ln -sf ~/dotfiles/diff-so-fancy/diff-so-fancy ~/dotfiles/bin/diff-so-fancy

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install exa
cargo install --locked bat
