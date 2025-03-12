
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS version with -E
  source <(fzf --zsh)
else
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target,.idea,.bsp,.metals,.bloop
  --preview 'tree -C {}'"

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target,.idea,.bsp,.metals,.bloop
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# CTRL-T interferes with zellij
bindkey -r '^T'
# Bind to alt-t instead
bindkey '\et' fzf-file-widget


_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}


# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# FZF-tab: https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#install
# No need to source. Auto sourced by plugin manager
#zsh_add_plugin "Aloxaf/fzf-tab"
#source $ZSH_CONFIGS/plugins/fzf-tab/fzf-tab.plugin.zsh

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts no
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Case-insensitive completion for fzf-tab
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Configure how tab should behave in fzf-tab
zstyle ':fzf-tab:*' continuous-trigger 'right'  # Use right arrow instead of tab temporarily
zstyle ':fzf-tab:*' fzf-bindings 'tab:down,btab:up,ctrl-j:accept,ctrl-k:kill-line'
# Use return key to accept selection
zstyle ':fzf-tab:*' accept-line 'ctrl-j'
# custom fzf flags and keybindings
zstyle ':fzf-tab:*' fzf-flags -i --height=40% --color=fg:1,fg+:2 --bind="tab:down,shift-tab:up,return:accept"

# Popups in tmux. They're to small
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup


