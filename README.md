My ZSH config
============

```
git clone git@github.com:jeffsaracco/zsh_config.git ~/zsh_config
ln -sf ~/dotfiles/home/zsh/zshrc ~/.zshrc
ln -sf ~/dotfiles/home/git/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/home/git/gitignore_global ~/.gitignore_global
ln -sf ~/dotfiles/home/config/nvim ~/.config/nvim
ln -sf ~/dotfiles/home/tmux/tmux.conf ~/.tmux.conf
cd ~/dotfiles
./macos
brew bundle
```

### Install tmux plugins

From inside a tmux session

```
<prefix> + I
```
