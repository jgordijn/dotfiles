# Atuin - enhanced shell history
# Set ZSH_ATUIN_ENABLED=true in your environment to enable
# For example, add to ~/.zshenv or a private module:
#   export ZSH_ATUIN_ENABLED=true

[[ "$ZSH_ATUIN_ENABLED" == "true" ]] || return

if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh)"
    # Bind Ctrl+R in vicmd mode as well (atuin only binds viins by default)
    bindkey -M vicmd '^R' atuin-search
fi
