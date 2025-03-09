
CACHE_LOCATION="$HOME/.cache"
# Functions to cache completion results
# For instance to use with az
cache_command() {
    local cache_name=$1
    shift
    local cache_file="$CACHE_LOCATION/completion_${cache_name}.cache"
    local temp_cache="${cache_file}.tmp"

    # If cache is missing or older than 10 minutes, refresh it
    # if [ ! -f "$cache_file" ] || [ "$(find "$cache_file" -mmin +10 2>/dev/null)" ]; then
    # -mtime +0 means older than 24 hours
    if [ ! -f "$cache_file" ] || [ "$(find "$cache_file" -mtime +0 2>/dev/null)" ]; then
        # Temporarily disable job notifications
        setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR

        # Start command in the background
        "$@" > "$temp_cache" 2>/dev/null &
        local pid=$!

        # Save cursor position and move to start of line
        printf "\033[s" >&2  # Save position
        printf "\033[1G" >&2  # Move to column 1

        # Spinner animation
        typeset -i i=0
        local sp="/-\|"
        while kill -0 $pid 2>/dev/null; do
            printf "%c" "${sp[i++%4]}" >&2
            printf "\033[1G" >&2  # Move back to start of line
            command true  # Force flush
            sleep 0.1
        done

        # Clear spinner and restore cursor
        printf "\033[K" >&2   # Clear line
        printf "\033[u" >&2   # Restore position

        # Only replace the cache file if the command was successful
        if wait $pid 2>/dev/null; then
            mv "$temp_cache" "$cache_file"
        else
            rm -f "$temp_cache"
        fi
    fi

    # Print cached results
    cat "$cache_file" 2>/dev/null
}

function reset_cache() {
    if [[ -n "$1" ]]; then
        local cache_file="$CACHE_LOCATION/completion_$1.cache"
        rm -f "$cache_file"
        echo "Cache file for '$1' deleted."
    else
        rm -f "$CACHE_LOCATION"/completion_*.cache
        echo "All cache files deleted."
    fi
}

