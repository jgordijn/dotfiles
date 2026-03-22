function clear-scrollback-buffer {
  # Behavior of clear: 
  # 1. clear scrollback if E3 cap is supported (terminal, platform specific)
  # 2. then clear visible screen
  # For some terminal 'e[3J' need to be sent explicitly to clear scrollback
  # clear && printf '\e[3J'
  printf "\ec\e[3J"
  # .reset-prompt: bypass the zsh-syntax-highlighting wrapper
  # https://github.com/sorin-ionescu/prezto/issues/1026
  # https://github.com/zsh-users/zsh-autosuggestions/issues/107#issuecomment-183824034
  # -R: redisplay the prompt to avoid old prompts being eaten up
  # https://github.com/Powerlevel9k/powerlevel9k/pull/1176#discussion_r299303453
  zsh_invoke_if_widget_shell zle .reset-prompt
  zsh_invoke_if_widget_shell zle -R
}

zsh_invoke_if_widget_shell zle -N clear-scrollback-buffer
zsh_invoke_if_widget_shell bindkey '^L' clear-scrollback-buffer
zsh_invoke_if_widget_shell bindkey -M viins '^L' clear-scrollback-buffer

# This will pause the current line. Allowing another command and then
# giving back the current line
zsh_invoke_if_widget_shell bindkey -M vicmd 'q' push-line

# CTRL-y will do the same as right arrow when there is a suggestion
zsh_invoke_if_widget_shell bindkey '^y' autosuggest-accept

