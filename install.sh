#!/bin/bash

# Check to see if the needed programs are installed.
for program in grep xclip pgrep pkexec whereis; do
  installed=$(command -v $program)
  [[ -z "$installed" ]] && echo "$program is not installed, please install it then run this again." && exit 1 || echo "$program is installed"
done

#Check to see if Java is installed:
javaver=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
requiredver="17.0.0"
 if [ "$(printf '%s\n' "$requiredver" "$javaver" | sort -V | head -n1)" = "$requiredver" ]; then
        echo "Installed Java Version is greater than ${requiredver}"
 else
        echo "Java Version installed is less than the required version of: Java ${requiredver} or isn't installed at all."
        exit 1
 fi

cd package
echo ">> Starting Integrator ..."
./integrator
echo ">> Installation Completed"
