<img width="200" src="https://camo.githubusercontent.com/66b25ab542ae255f3782bba56595679faa52c6214ecbec8d38e3403d2e5a3d6b/68747470733a2f2f666f7274686562616467652e636f6d2f696d616765732f6261646765732f776f726b732d6f6e2d6d792d6d616368696e652e737667" alt="Material Bread logo">

*Installation script should be run as:*
```
. install.sh
```


### Info

-  **OS:** Manjaro
-  **WM:** i3
-  **Terminal:** Termite
-  **Terminal Font:** Noto Sans Mono
-  **System Font:** Noto Sans
-  **Compositor:** [Picom](https://github.com/yshui/picom)
-  **Bar/Panel:** Polybar
-  **Text Editor:** Vim
-  **GTK Theme:** [Coffee](https://github.com/danielammartins/KDEdotfiles/tree/main/.themes/Coffee) 
-  **Icons:** Foggy Mountain
-  **Cursor:** Adwaita
-  **Application Launcher:** rofi

## Install

* Set fastest mirrors
``` 
sudo pacman-mirrors --fasttrack 
```
* Enable SSD trimming
```
sudo systemctl enable fstrim.timer
```
* Check for errors
```
sudo systemctl --failed
```
* General system update
```
sudo pacman -Syu
```
* AUR Helper (currently using Paru)
```
sudo pacman -S --needed base-devel
cd /opt
sudo git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```
* Clone the dotfiles
```
cd ~/Documents
git clone https://github.com/danielammartins/i3dots
```
* Install packages
``` 
cd ~/Documents/i3dots/packages
# Packages from the Official Repositories
pacman -S $(cat official_packages.txt)
# AUR packages
paru -S $(cat aur_packages.txt)
```
* Override i3 config file
```
cd ~/Documents/i3dots/.i3/
/bin/cp config ~/.i3/config
```
* Configure polybar
```
cp -r /polybar ~/.config
```
* Overwrite the bashrc file in Documents with the bashrc from the dotfiles
```
cd ~/Documents/i3dots
/bin/cp .bashrc ~/
```
* Copy the theme folder to the installed themes folder
 ```
 cd ~/Documents/i3dots/.themes
 cp -r Coffee/ /usr/share/themes/

 ```
 * Change theme, mouse and icons in lxappearance
     * Change the GTK theme to Coffee
     * Change the mouse coursor to Adwaita
     * Install the Foggy Mountain.tar.gz icon set located in ~/Documents/i3dots/icons

* Set wallpaper
```
cd ~/Documents/i3dots/walls
sudo cp forest_road_winding_151202_3840x2160.jpg /usr/share/backgrounds/ 
feh --bg-scale /usr/share/backgrounds/forest_road_winding_151202_3840x2160.jpg
```
* Set firefox as default browser
```
export BROWSER=""			
xdg-settings set default-web-browser firefox.desktop
```
* Copy the .config files 
```
cp -r dunst/ rofi/ /spicetify /termite ~/.config
```
* Configure Spicetify
```
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
spicetify
spicetify backup apply enable-devtool
spicetify update
```

