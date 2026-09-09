alias l='ls -lFh'
alias la='ls -lAFh'
alias lr='ls -tRFh'
alias lt='ls -ltFh'
alias ldot='ls -ld -- .*'

zshrc() {
  "$EDITOR" "${ZDOTDIR:-$HOME}/.zshrc"
}

hgrep() {
  fc -El 0 | command grep -- "$@"
}

alias t='tail -f'
alias ncdug='ncdu --color dark -rr -x --exclude .git --exclude node_modules'
