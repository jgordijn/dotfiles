# Base functions that are required throughout my zsh
# Include this at the top of your .zshrc


# Self rolled plugin manager
# see: https://www.reddit.com/r/zsh/comments/1iurg4z/comment/me4w1g9/?context=3&share_id=d90wJd78Smc2CA9CSmq7j&utm_content=1&utm_medium=ios_app&utm_name=iossmf&utm_source=share&utm_term=22
function zsh_add_plugin() {
    local plugindir=$HOME/.config/zsh
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    # First check if we have the plugin at all:
    if [ ! -d "$plugindir/plugins/$PLUGIN_NAME" ]; then
        git clone "https://github.com/$1.git" "$plugindir/plugins/$PLUGIN_NAME"
    fi
    # Initialize the plugin:
    if [ -d "$plugindir/plugins/$PLUGIN_NAME" ]; then
        # For plugins
        source "$plugindir/plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
            source "$plugindir/plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    fi
}