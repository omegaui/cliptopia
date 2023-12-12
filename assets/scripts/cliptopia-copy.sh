#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: cliptopia-copy.sh <TARGET>"
    exit 1
fi

xclip -selection clipboard -t "$1" < /tmp/.cliptopia-temp-text-data &> /dev/null