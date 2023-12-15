#!/bin/bash

# Check to see if the needed programs are installed:
for program in grep xclip pgrep pkexec whereis wl-copy wl-paste; do
  installed=$(command -v $program)
  [[ -z "$installed" ]] && echo "$program is not installed, please install it then run this again." && exit 1 || echo "$program is installed"
done

# Set version of required Java, as well as create a variable to check what version of java is installed:
requiredver="17.0.0"
javaver=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')

# Now lets do the comparison
if [ "$(printf '%s\n' "$requiredver" "$javaver" | sort -V | head -n1)" = "$requiredver" ]; then
      echo "Installed Java Version is greater than ${requiredver}"
else
      echo "Java Version installed is less than the required version of: Java ${requiredver} or isn't installed at all."
      exit 1
fi

# Set version of required Flutter, as well as re-use the requiredver variable to check what version of flutter is installed:
requiredver="3.16.0"
flutterver=$(flutter --version | awk 'NR==1 {print $2}')

# Now lets do the comparison
if [ "$(printf '%s\n' "$requiredver" "$flutterver" | sort -V | head -n1)" = "$requiredver" ]; then
      echo "Installed Flutter Version is greater than ${requiredver}"
else
      echo "Flutter Version installed is less than the required version of: Flutter ${requiredver} or isn't installed at all."
      exit 1
fi

# bundling

flutter build linux --release
rm -rf package/bundle
cp -r build/linux/x64/release/bundle package/

# preparing /app root

directory="/opt/cliptopia"

if [ -d "$directory" ]; then
    echo "App binary root already exists ..."
    echo "Reintegrating Cliptopia ..."
else
    sudo mkdir $directory
fi

echo "  >> Copying Bundle to /opt/cliptopia ..."
sudo cp -r package/bundle/* /opt/cliptopia

#  Now lets install
cd package
./integrator
