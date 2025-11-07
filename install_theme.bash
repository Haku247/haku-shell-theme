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

echo -e \"\n\033[1;36m===== System Information =====\033[0m\n\"

if command -v tmux >/dev/null 2>&1; then
    tmux_sessions=\$(tmux ls 2>/dev/null)
    if [[ -n \"\$tmux_sessions\" ]]; then
        echo -e \"\033[1;33m\$tmux_sessions\033[0m\"
    else
        echo -e \"\033[1;33mNo active tmux sessions.\033[0m\"
    fi
else
    echo -e \"\033[1;31mtmux is not installed.\033[0m\"
fi

mem_total=\$(free -h | awk '/Mem:/ {print \$2}')
echo -e \"\033[1;37mTotal Memory:\033[0m \$mem_total\"

cpu_model=\$(grep -m1 \"model name\" /proc/cpuinfo | sed 's/^.*: //')
cores_per_socket=\$(lscpu | awk '/Core\\(s\\) per socket/ {print \$4}')
sockets=\$(lscpu | awk '/Socket\\(s\\)/ {print \$2}')
if [[ -z \"\$cores_per_socket\" ]]; then
    cores_per_socket=1
fi
if [[ -z \"\$sockets\" ]]; then
    sockets=1
fi
total_cores=\$((cores_per_socket * sockets))
total_threads=\$(nproc)
echo -e \"\033[1;37mCPU:\033[0m \$cpu_model \033[0;32m(\${total_cores}C/\${total_threads}T)\033[0m\"

gpu_line=\$(lspci | grep -i 'vga\\|3d\\|2d' | head -n 1 | sed 's/^.*: //')
if [[ -n \"\$gpu_line\" ]]; then
    echo -e \"\033[1;37mGPU:\033[0m \$gpu_line\"
else
    echo -e \"\033[1;37mGPU:\033[0m Not detected\"
fi

$(cat \"$script_dir/haku-shell-theme.bash\")
$marker_end"

# Append the theme block to the .bashrc file
echo "$theme_block" >> "$bashrc"

# Source the .bashrc file to apply the theme immediately
source "$bashrc"

echo "The haku-shell-theme has been installed!"
