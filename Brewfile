# vim: set ft=ruby:
def macos?
  RUBY_PLATFORM =~ /darwin/
end

def linux?
  RUBY_PLATFORM =~ /linux/
end


tap 'heroku/brew'
tap 'homebrew/bundle'
tap 'homebrew/services'
tap 'neovim/neovim'

brew 'autoconf'
brew 'automake'
brew 'bat'
brew 'boost'
brew 'cmake'
brew 'coreutils'
brew 'diff-so-fancy'
brew 'fd'
brew 'findutils'
brew 'fswatch'
brew 'fzf'
brew 'gnupg'
brew 'grc'
brew 'htop'
brew 'hyperscan'
brew 'icu4c'
brew 'imagemagick'
brew 'jansson'
brew 'jq'
brew 'launch_socket_server', restart_service: true
brew 'launchdns', restart_service: true
brew 'lcov'
brew 'libtool'
brew 'libxml2'
brew 'libyaml'
brew 'md5sha1sum'
brew 'memcached', restart_service: true
brew 'mysql', restart_service: true
brew 'ncdu'
brew 'neovim'
brew 'nginx', restart_service: true
brew 'node'
brew 'node-build'
brew 'nodenv'
brew 'noti'
brew 'openssl'
brew 'pidof'
brew 'pinentry-mac'
brew 'pkg-config'
brew 'protobuf'
brew 'python'
brew 'python3'
brew 'rbenv'
brew 'readline'
brew 'redis', restart_service: true
brew 'ripgrep'
brew 'ruby-build'
brew 'shellcheck'
brew 'socat'
brew 'softhsm'
brew 'sqlite'
brew 'tldr'
brew 'tmux'
brew 'wget'
brew 'gawk'
cask 'docker'
cask 'gitify'
cask 'graphiql'
cask 'vagrant'
cask 'virtualbox'
cask 'viscosity'

if macos?
  brew 'git'
  brew 'go'
  brew 'hub'
  brew 'docker', link: false
  brew 'docker-compose'
  brew 'docker-machine', link: false
  brew 'postgresql', restart_service: true
  brew 'reattach-to-user-namespace'
end
