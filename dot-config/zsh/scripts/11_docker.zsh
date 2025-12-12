# Check if docker exists, otherwise use podman if available
if command -v docker &> /dev/null; then
    # Load docker completions
    # the brew version does not work for compose
    source <(docker completion zsh)
elif command -v podman &> /dev/null; then
    # Use podman as docker replacement
    alias docker="podman"
    source <(podman completion zsh)
fi



alias d="docker"
alias dc="docker compose"
alias dps="docker ps"
alias dcl="docker compose logs"
alias dcps="docker compose ps"
alias dcup="docker compose up"
alias dcdn="docker compose down"
alias dcupd="docker compose up -d"


