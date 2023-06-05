#!/bin/sh
NOW=$(date +%s)
grim -g "$(slurp )" -t jpeg $HOME/Pictures/Screenshot-$NOW.jpg
feh $HOME/Pictures/Screenshot-$NOW.jpg
