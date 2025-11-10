alias kns='kubens'
alias kctx='kubectx'


function showImage() {
    jq -r '.. | select(type=="object") | select(.image != null) | .image'
}

# Create a global alias FL that can be used anywhere in the command
alias -g SI=' -o json | showImage'
alias -g Y="-o yaml | bat -p -l yaml"
alias -g YX="-o yaml | fx --yaml"
alias -g J="-o json"
alias -g JX="-o json | fx"



