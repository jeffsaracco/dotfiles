#!/usr/bin/env zsh

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git submodule add https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git submodule add https://github.com/supercrabtree/k ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/k
git submodule add https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins

ln -sf ~/dotfiles/home/zsh/zshrc ~/.zshrc
ln -sf ~/dotfiles/home/git/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/home/git/gitignore_global ~/.gitignore_global
ln -sf ~/dotfiles/home/config/nvim ~/.config/nvim
ln -sf ~/dotfiles/home/config/alacritty ~/.config/alacritty
ln -sf ~/dotfiles/home/tmux/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/home/config/tmuxinator ~/.config/tmuxinator
ln -sf ~/dotfiles/home/atom ~/.atom
ln -sf ~/dotfiles/home/noti/noti.yml ~/.noti.yaml
ln -sf ~/dotfiles/home/hyper.js ~/.hyper.js

mkdir ~/.tmux/
git clone https://github.com/tmux-plugins/tpm ~/dotfiles/home/tmux/plugins/tpm

ln -sf ~/dotfiles/diff-so-fancy/diff-so-fancy ~/dotfiles/bin/diff-so-fancy

ln -sf ~/dotfiles/home/dotbin/tmuxinator.zsh ~/.bin/tmuxinator.zsh
ln -sf ~/dotfiles/home/p10k.zsh ~/.p10k.zsh

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install exa
cargo install --locked bat

# Install FZF extensions
$(brew --prefix)/opt/fzf/install
