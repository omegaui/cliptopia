#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: cliptopia-command-executor.sh <COMMAND>"
    exit 1
fi

# Check if gnome-terminal is available
if command -v gnome-terminal &> /dev/null; then
    gnome-terminal -- bash -c "$1; exec bash"
    exit 0
fi

# Check if xterm is available
if command -v xterm &> /dev/null; then
    xterm -e "$1"
    exit 0
fi

# Check if konsole is available (for KDE)
if command -v konsole &> /dev/null; then
    konsole -e "$1"
    exit 0
fi

# Check if mate-terminal is available (for MATE desktop)
if command -v mate-terminal &> /dev/null; then
    mate-terminal -e "$1"
    exit 0
fi

# Check if lxterminal is available (for LXDE)
if command -v lxterminal &> /dev/null; then
    lxterminal -e "$1"
    exit 0
fi

# Check if xfce4-terminal is available (for Xfce)
if command -v xfce4-terminal &> /dev/null; then
    xfce4-terminal -e "$1"
    exit 0
fi

# None of the above terminals are available
echo "Error: No supported terminal emulator found."
exit 1
