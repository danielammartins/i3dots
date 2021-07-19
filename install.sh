#!/bin/bash

function show_menu() {
	echo "Welcome to an i3 fresh install!"
	echo "This script will:"
	echo "- Set the fastest mirror"
	echo "- Enable SSD trimming"
	echo "- Perform a full system update"
	echo "- Check for errors"
	echo "- Install the AUR helper"
	echo "- Install the packages @ official_packages.txt and aur_packages.txt"
	echo "- Set the wallpaper"
	echo "- Configure polybar"

	choose_to_proceed
}

function choose_to_proceed() {
	echo "Do you wish to proceed? Y/N:"

	read opt

	while [ "$opt" != "Y" ] && [ "$opt" != "y" ] && [ "$opt" != "N" ] && [ "$opt" != "n" ]; do
	echo "Please enter a valid command."
	echo "Do you wish to proceed? Y/N:"
	read opt
	echo $opt
	done

	if [ "$opt" == "Y" ] || [ "$opt" == "y" ]; then
		temp_install
	elif [ "$opt" == "N" ] || [ "$opt" == "n" ]; then
		echo "Bye bye"	
	else 
		echo "Error. Aborting..."
	fi
}


function install() {
	# Set up mirror list 
	sudo pacman-mirrors --fasttrack

	# Enable SSD trimming
	sudo systemctl enable fstrim.timer

	# General system update
	sudo pacman -Syu

	# Check for errors
	sudo systemctl --failed

	# AUR Helper (currently using Paru)
	sudo pacman -S --needed base-devel
	cd /opt
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si

	# Packages from the Official Repositories
	pacman -S $(cat official_packages.txt)

	#
	# AUR packages
	#
	paru -S $(cat aur_packages.txt)

	# Overwrite i3 config files
	cd /home/dani/Documents/i3dots/.i3/
	/bin/cp config /home/dani/.i3/config

	# Overwrite the bashrc file in Documents with the bashrc from the dotfiles
	cd /home/dani/Documents/i3dots
	/bin/cp .bashrc /home/dani/Documents   

	# Get wallpaper from dotfiles, copy to /usr/share/backgrounds/ for future user and set with feh
	cd /home/dani/Documents/i3dots/walls
	sudo cp forest_road_winding_151202_3840x2160.jpg /usr/share/backgrounds/ 
	feh --bg-scale /usr/share/backgrounds/forest_road_winding_151202_3840x2160.jpg

	# Set Firefox as default browser
	export BROWSER=""			
	xdg-settings set default-web-browser firefox.desktop

	#Polybar
}

show_menu