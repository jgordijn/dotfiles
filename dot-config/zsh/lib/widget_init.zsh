# Helpers for widget and keymap setup that should only run in real terminals.

zsh_is_widget_shell() {
  [[ -o interactive ]] && [[ -t 0 ]] && [[ -t 1 ]]
}

zsh_invoke_if_widget_shell() {
  zsh_is_widget_shell || return 0
  "$@"
}
