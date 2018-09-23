while inotifywait -e modify .; do
    echo restarting 
    pkill polybar
    polybar main &
    echo done
done

