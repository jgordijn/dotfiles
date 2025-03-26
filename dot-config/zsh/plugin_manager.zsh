# Base functions that are required throughout my zsh
# Include this at the top of your .zshrc
export ZSH_PLUGINS=$ZSH_DATA_DIR/managed-plugins

# Self rolled plugin manager
# see: https://www.reddit.com/r/zsh/comments/1iurg4z/comment/me4w1g9/?context=3&share_id=d90wJd78Smc2CA9CSmq7j&utm_content=1&utm_medium=ios_app&utm_name=iossmf&utm_source=share&utm_term=22
function zsh_add_plugin() {
    #local plugindir=$HOME/.config/zsh
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    # First check if we have the plugin at all:
    if [ ! -d "$ZSH_PLUGINS/$PLUGIN_NAME" ]; then
        git clone "https://github.com/$1.git" "$ZSH_PLUGINS/$PLUGIN_NAME"
    fi
    # Initialize the plugin:
    if [ -d "$ZSH_PLUGINS/$PLUGIN_NAME" ]; then
        # For plugins
        source "$ZSH_PLUGINS/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
            source "$ZSH_PLUGINS/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    fi
}

function update_plugins() {
    echo "Time to update plugins"
    for plugin in $ZSH_PLUGINS/*; do
        if [ -d "$plugin" ]; then
            echo "Updating $plugin"
            cd $plugin
            git pull
        fi
    done
}

# Run the update_plugins function at most once per day
LAST_UPDATE_FILE="$ZSH_DATA_DIR/.last_plugin_update"
if [[ ! -f "$LAST_UPDATE_FILE" ]] && [[ $(find "$LAST_UPDATE_FILE" -mtime +1 -print) ]]; then
    update_plugins
    touch "$LAST_UPDATE_FILE"
fi

