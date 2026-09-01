# Use Emacs-style line editing, with Ctrl-Left/Right for word navigation.
zsh_invoke_if_widget_shell bindkey -e
zsh_invoke_if_widget_shell bindkey '^[[1;5D' backward-word
zsh_invoke_if_widget_shell bindkey '^[[1;5C' forward-word

# Ctrl-X Ctrl-E opens the current command line in $EDITOR.
autoload -Uz edit-command-line
zsh_invoke_if_widget_shell zle -N edit-command-line
zsh_invoke_if_widget_shell bindkey '^X^E' edit-command-line
