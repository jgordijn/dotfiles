# Load docker completions
# the brew version does not work for compose
source <(docker completion zsh)

alias d="docker"
alias dc="docker compose"
alias dps="docker ps"
alias dcl="docker compose logs"
alias dcps="docker compose ps"
alias dcup="docker compose up"
alias dcdn="docker compose down"
alias dcupd="docker compose up -d"


