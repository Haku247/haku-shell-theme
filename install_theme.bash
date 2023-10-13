#!/bin/bash

# Path to the user's .bashrc file
bashrc="$HOME/.bashrc"

# ANSI escape code for yellow text
yellow='\033[1;33m'
# ANSI escape code to reset text color
reset='\033[0m'

# Check if PS1 is set somewhere else in .bashrc
if grep -q "PS1=" "$bashrc"; then
    echo -e "${yellow}Warning: PS1 is set elsewhere in your .bashrc file. This may interfere with the haku-shell-theme.${reset}"
fi

# Check if color_prompt is not set to yes
if ! grep -q "color_prompt=yes" "$bashrc"; then
    echo -e "${yellow}Warning: color_prompt is not set to yes in your .bashrc file. The haku-shell-theme will not be applied.${reset}"
fi

# Path to the directory containing this script
script_dir=$(dirname "$0")

# The bash theme
bash_theme=$(cat "$script_dir/haku-shell-theme.bash")

# Add the theme to the .bashrc file
echo "$bash_theme" >> "$bashrc"

# Source the .bashrc file to apply the theme immediately
source "$bashrc"

echo "The haku-shell-theme has been installed!"
