#!/bin/bash

# Path to the user's .bashrc file
bashrc="$HOME/.bashrc"

# ANSI escape code for yellow text
yellow='\033[1;33m'
# ANSI escape code to reset text color
reset='\033[0m'

marker_start="# >>> haku-shell-theme start >>>"
marker_end="# <<< haku-shell-theme end <<<"

# Automatically remove any previous haku-shell-theme block (between markers)
if grep -qF "$marker_start" "$bashrc" && grep -qF "$marker_end" "$bashrc"; then
    # Remove everything between the markers, including the markers
    sed -i.bak "/$marker_start/,/$marker_end/d" "$bashrc"
    echo "Previous haku-shell-theme block removed from .bashrc."
fi

# Prompt user to choose time zone (always prompt, even after cleanup)
echo "Choose your preferred time zone:"
echo "1) Chicago (CST/CDT)"
echo "2) Shanghai (CST, UTC+8)"
read -p "Enter your choice (1 or 2): " timezone_choice

if [[ "$timezone_choice" == "1" ]]; then
    timezone="America/Chicago"
elif [[ "$timezone_choice" == "2" ]]; then
    timezone="Asia/Shanghai"
else
    echo -e "${yellow}Invalid choice. Defaulting to Chicago time zone.${reset}"
    timezone="America/Chicago"
fi

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

theme_block="$marker_start
export TZ=$timezone

echo \"\n===== System Information =====\"
if command -v tmux >/dev/null 2>&1; then
    tmux ls 2>/dev/null || echo \"No active tmux sessions.\"
else
    echo \"tmux is not installed.\"
fi
free -h | awk '/Mem:/ {print \"Total Memory: \" \$2}'
grep -m1 \"model name\" /proc/cpuinfo | sed 's/^.*: //'
lspci | grep -i 'vga\\|3d\\|2d' | head -n 1 | sed 's/^.*: //'

$(cat \"$script_dir/haku-shell-theme.bash\")
$marker_end"

# Append the theme block to the .bashrc file
echo "$theme_block" >> "$bashrc"

# Source the .bashrc file to apply the theme immediately
source "$bashrc"

echo "The haku-shell-theme has been installed!"
