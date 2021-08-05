#!/bin/bash

function show_menu() {
	echo "Welcome to an i3 fresh install!"
	echo -e "\n"
	echo "This script will:"
	echo "- Set the fastest mirror"
	echo "- Enable SSD trimming"
	echo "- Perform a full system update"
	echo "- Check for errors"
	echo "- Install the AUR helper"
	echo "- Install the packages @ official_packages.txt and aur_packages.txt"
	echo "- Set the wallpaper"
	echo "- Configure polybar"
	echo -e "\n"

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
		install
	elif [ "$opt" == "N" ] || [ "$opt" == "n" ]; then
		echo "Bye bye"	
	else 
		echo "Error. Aborting..."
	fi
}


function install() {
	echo -e "\nStarting..."

	# Set up mirror list 
	sudo pacman-mirrors --fasttrack
	echo -e "Mirror list updated!\n"

	# Enable SSD trimming
	sudo systemctl enable fstrim.timer
	echo -e "SSD trimming enabled!\n"

	# Check for errors
	echo -e "Checking for errors..."
	sudo systemctl --failed
	echo -e "\n"
	
	# General system update
	sudo pacman -Syu
	echo -e "System updated!\n"

	# AUR Helper (currently using Paru) 
	sudo pacman -S --needed base-devel
	cd /opt/
	sudo git clone https://aur.archlinux.org/paru.git
	cd paru
	sudo chmod a+w /opt/paru 
	makepkg -si
	echo -e "Paru installed!\n"

	# Packages from the Official Repositories
	sudo pacman -S $(cat official_packages.txt)

	# AUR packages
	paru -S $(cat aur_packages.txt)

	# Overwrite i3 config file
	cd ~/Documents/i3dots/.i3/
	/bin/cp config ~/.i3/config
	echo -e "i3 config updated!\n"

	# Overwrite dunst config file
	cd ~/Documents/i3dots/.config/dunst
	/bin/cp dunstrc ~/.config/dunst/
	echo -e "dunst config updated!\n"

	# Overwrite termite config file
	cd ~/Documents/i3dots/.config/termite
	/bin/cp config ~/.config/termite/
	echo -e "termite config updated!\n"

	# Overwrite picom config file
	cd ~/Documents/i3dots/.config/
	/bin/cp picom.conf ~/.config/
	echo -e "picom config updated!\n"

	# Overwrite rofi config and theme
	cd ~/Documents/i3dots/.config/rofi
	/bin/cp config ~/.config/rofi
	/bin/cp pinky.rasi ~/.config/rofi
	echo -e "rofi config updated!\n"

	# Overwrite the bashrc file in Home with the bashrc from the dotfiles
	cd ~/Documents/i3dots
	/bin/cp .bashrc ~/
	echo -e "bashrc config updated!\n"

	# Get wallpaper from dotfiles, copy to /usr/share/backgrounds/ for future use and set with feh
	cd ~/Documents/i3dots/walls
	sudo cp forest_road_winding_151202_3840x2160.jpg /usr/share/backgrounds/ 
	feh --bg-scale /usr/share/backgrounds/forest_road_winding_151202_3840x2160.jpg
	echo -e "Wallpaper set!\n"

	# Set Firefox as default browser
	export BROWSER=""			
	xdg-settings set default-web-browser firefox.desktop
	echo -e "Firefox is set as default browser!\n"

	# Noto Sans Emoji
	sudo pacman -S noto-fonts-emoji
	cd ~/Documents/i3dots/etc/fonts/
	sudo /bin/cp local.conf /etc/fonts/local.conf
	echo -e "Font config updated!\n"

	# Polybar
	paru -S polybar
	sudo pacman -S xorg-fonts-misc
	paru -S siji-git ttf-unifont
	mkdir ~/.config/polybar
	mkdir ~/.config/polybar/modules
	cp ~/Documents/i3dots/.config/polybar/config ~/.config/polybar/
	cp ~/Documents/i3dots/.config/polybar/launch.sh ~/.config/polybar/
	cp ~/Documents/i3dots/.config/polybar/modules/spotify_status.py ~/.config/polybar/modules
	sudo chown dani:dani ~/.config/polybar/config
	sudo chmod +x ~/.config/polybar/launch.sh
	echo -e "Polybar set!\n"

	# Install icons
	sudo pacman -S unzip
	cd ~/Documents/i3dots/icons
	tar -xzf Foggy.tar.gz 
	sudo mv 'Foggy Mountain/' /usr/share/icons
	cd ~
	echo -n "Icons installed!/n"

	# Install theme
	sudo /bin/cp -r ~/Documents/i3dots/.themes/Coffee /usr/share/themes/
	echo -n "Theme installed!/n"

	# Set GTK theme, icons and cursor theme
	sed -i '2s/.*/gtk-icon-theme-name=Foggy Mountain/' ~/.config/gtk-3.0/settings.ini
	sed -i '3s/.*/gtk-theme-name=Coffee/' ~/.config/gtk-3.0/settings.ini
	sed -i '4s/.*/gtk-cursor-theme-name=Adwaita/' ~/.config/gtk-3.0/settings.ini
	echo -n "GTK theme, icons and cursor are set!/n"

	# Firefox custom CSS
	echo -n "Please make sure to take the following steps in Firefox to ensure the custom theme is applied:"
	echo -n "	- Navigate to about:config in the address bar and accept the risks;"	
	echo -n "	- Search for toolkit.legacyUserProfileCustomizations.stylesheets and toggle it to true;"
	echo -n "	- Open DevTools, go to Settings > Advanced Settings and enable browser chorme, add-on debugging toolboxes and remote debugging."	
	mkdir ~/.mozilla/firefox/mdy712pv.default-release/chrome/
	cd ~/Documents/i3dots/firefox/chrome/
	mv userChrome.css userContent.css ~/.mozilla/firefox/mdy712pv.default-release/chrome/ 
	echo -n "Firefox CSS is updated!\n"
}

show_menu

# Restart i3
i3-msg restart

cd ~
echo "Instalation completed!"
echo "Bye bye!"