#!/bin/bash

# set shotcut verion
#shotcut_ver=24.11.17
shotcut_ver=$(curl -fsSL "https://www.shotcut.org/download/" | grep -oP 'Current Version:\s*\K[0-9.]+')

if [ $# -eq 0 ]; then
	echo "No arguments provided."
	echo "Usage: $0 {install|uninstall}"
else
	for arg in "$@"; do
		if [[ $arg == "install" ]]; then
			echo "Installing shotcut..."

			# download shutcut portable tarball
			wget -P /tmp https://github.com/mltframework/shotcut/releases/download/v${shotcut_ver}/shotcut-linux-x86_64-${shotcut_ver}.txz

			# check current installed shotcut portable program and backup
			if [ -d "$HOME/Shotcut.app" ]; then
				echo "$HOME/Shotcut.app does exist. Backup current Shotcut folder first."
				mv $HOME/Shotcut.app $HOME/Shotcut.app_`date +%Y_%d_%m_%H_%M_%S`
			fi

			# untar tarball
			tar -xvf /tmp/shotcut-*.txz -C $HOME

			# symlink shotcut
			if [ ! -f "$HOME/.local/bin/shotcut" ]; then
				mkdir -p $HOME/.local/bin
				ln -s $HOME/Shotcut.app/shotcut $HOME/.local/bin/shotcut
			fi
			if [ ! -f "$HOME/.local/share/applications/Shotcut.desktop" ]; then
				mkdir -p $HOME/.local/share/applications
				ln -s $HOME/Shotcut.app/share/applications/org.shotcut.Shotcut.desktop $HOME/.local/share/applications/Shotcut.desktop
    		fi
		elif [[ $arg == "uninstall" ]]; then
			# remove shotcut
			echo "Uninstalling shotcut..."
			rm $HOME/.local/bin/shotcut
			rm $HOME/.local/share/applications/Shotcut.desktop
			rm -r $HOME/Shotcut*
		fi
	done
fi
