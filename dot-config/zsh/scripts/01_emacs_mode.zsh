# Use Emacs-style line editing. Option-Left/Right move by word.
zsh_invoke_if_widget_shell bindkey -e

# Ctrl-X Ctrl-E opens the current command line in $EDITOR.
autoload -Uz edit-command-line
zsh_invoke_if_widget_shell zle -N edit-command-line
zsh_invoke_if_widget_shell bindkey '^X^E' edit-command-line
