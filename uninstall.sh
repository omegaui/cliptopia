#!/bin/bash
echo ">> Uninstalling Cliptopia ..."
rm -rf ~/.config/cliptopia
cliptopia-daemon --stop
sudo rm /usr/bin/cliptopia
sudo rm /usr/bin/cliptopia-daemon
sudo rm -rf /opt/cliptopia
echo ">> Uninstalling Completed !!"