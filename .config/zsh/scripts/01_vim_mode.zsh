# Set a shorter timeout for switching between modes (in hundredths of a second)

export KEYTIMEOUT=1
# Set default keybinding to viins
bindkey -v

#autoload -Uz edit-command-line
#zle -N edit-command-line


## Show mode indicator in prompt
#function zle-line-init zle-keymap-select {
#    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
#    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}"
#    zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select

# Add custom keybindings for vi mode
# Use v to edit in editor
#bindkey -M vicmd "v" edit-command-line

