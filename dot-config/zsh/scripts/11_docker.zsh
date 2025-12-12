# Suppress podman compose warning about external provider
export PODMAN_COMPOSE_WARNING_LOGS=false

# Check if docker exists, otherwise use podman if available
if command -v docker &> /dev/null; then
    # Load docker completions
    source <(docker completion zsh)
elif command -v podman &> /dev/null; then
    # Use podman as docker replacement
    alias docker="podman"
    source <(podman completion zsh)
fi

# Completion for docker compose / podman-compose
# Gets service names from compose file when available
__docker_compose_services() {
    local -a services
    services=(${(f)"$(podman-compose config --services 2>/dev/null)"})
    if (( ${#services} > 0 )); then
        _describe -t services 'service' services
    fi
}

__docker_compose_subcommands() {
    local -a commands=(
        'build:Build or rebuild services'
        'config:Validate and view the Compose file'
        'down:Stop and remove containers, networks'
        'exec:Execute a command in a running container'
        'help:Show help'
        'images:List images used by the created containers'
        'kill:Kill containers'
        'logs:View output from containers'
        'pause:Pause services'
        'port:Print the public port for a port binding'
        'ps:List containers'
        'pull:Pull service images'
        'push:Push service images'
        'restart:Restart services'
        'run:Run a one-off command'
        'start:Start services'
        'stats:Display container resource usage statistics'
        'stop:Stop services'
        'unpause:Unpause services'
        'up:Create and start containers'
        'version:Show version'
        'wait:Wait for services to be healthy'
    )
    _describe -t commands 'compose command' commands
}

# Commands that accept service names as arguments
__docker_compose_service_commands=(logs exec run start stop restart build pull push pause unpause kill up)

_docker_compose() {
    local curcontext="$curcontext" state line
    _arguments -C \
        '-f[Compose file]:file:_files -g "*.y(a|)ml"' \
        '--file[Compose file]:file:_files -g "*.y(a|)ml"' \
        '-p[Project name]:name:' \
        '--project-name[Project name]:name:' \
        '1: :__docker_compose_subcommands' \
        '*:: :->args'

    case $state in
        args)
            local cmd=${line[1]}
            if (( ${__docker_compose_service_commands[(Ie)$cmd]} )); then
                __docker_compose_services
            else
                _files
            fi
            ;;
    esac
}

# Wrapper for docker completion that handles 'compose' subcommand
_docker_with_compose() {
    if [[ ${words[2]} == "compose" ]]; then
        # Shift words to make compose the "command"
        shift words
        (( CURRENT-- ))
        _docker_compose
    else
        _docker "$@"
    fi
}

compdef _docker_with_compose docker
compdef _docker_compose dc



alias d="docker"
alias dc="docker compose"
alias dps="docker ps"
alias dcl="docker compose logs"
alias dcps="docker compose ps"
alias dcup="docker compose up"
alias dcdn="docker compose down"
alias dcupd="docker compose up -d"


