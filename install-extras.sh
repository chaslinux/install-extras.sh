#!/bin/bash
# Script started by Charles McColm, cr@theworkingcentre.org
# for The Working Centre's Computer Recycling Project
# Installs a bunch of extra software that's useful for our
# Xubuntu 20.04, 22.04, and now Linux Mint Una
# Special thanks to Cecylia Bocovich for assistance with automating parts of the script
# https://github.com/cohosh
#
# Just run as ./install-extras.sh, don't run as sudo ./install-extras.sh


# set the current directory
currentdir=$(pwd)

# Run updates first as some software may not install unless the system is
# updated
sudo apt update && sudo apt upgrade -y

# Install flatpak and support files
sudo apt install flatpak -y
sudo apt install gnome-software-flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


distro=$(cat /etc/lsb-release | grep CODENAME)
if [ $distro == 'DISTRIB_CODENAME=jammy' ] || [ $distro == 'DISTRIB_CODENAME=focal' ] || [ $distro == "noble" ]
	then
		# Let's not do any snaps anymore -- this is getting ridiculous

		# Install OnlyOffice 7.0 since it looks a bit closer to MS Office
		onlyoffice=$(dpkg -s onlyoffice-desktopeditors | grep Status)
		if [ ! "$onlyoffice" == "Status: install ok installed" ]
			then
				wget -O onlyoffice.deb https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
				sudo dpkg -i onlyoffice.deb
				sudo apt --fix-broken install -y
			else
				echo "OnlyOffice is already installed"
		fi

		# install Zoom for conferencing
		zoom=$(dpkg -s zoom | grep Status)
		if [ ! "$zoom" == "Status: install ok installed" ]
			then
			  echo "Installing Zoom"
			  wget -O zoom.deb https://zoom.us/client/latest/zoom_amd64.deb
			  sudo dpkg -i zoom.deb
			  sudo apt --fix-broken install -y
			else
			  echo "Zoom is already installed"
		fi

	else
        echo "Not a modern version of *buntu"
fi

# Removed the Linux Mint Una section

# install htop, mc, curl, git and build-essential because they're awesome tools
sudo apt install htop mc curl git build-essential acpi -y

# Install webp support, but only for jammy
if [ $distro == 'DISTRIB_CODENAME=jammy' ] || [ $distro == "noble" ]
	then
		# install webp-pixbuf-loader because it lets you preview webp images in thunar and load them in ristretto
		sudo apt install webp-pixbuf-loader -y
	else
		echo "Not Jammy, so no webp-pixbuf-loader"
fi	

# install Timeshift for system backups
# removed stacer and geany 08/15/2022
echo "Installing Timeshift, Steam and MS TTF Fonts"
sudo DEBIAN_FRONTEND=noninteractive apt install timeshift steam ttf-mscorefonts-installer -y


# install guvcview and cheese - cheese has issues with some webcams
echo "Installing guvcview"
sudo apt install guvcview cheese -y

# installing VLC
echo "Installing VLC"
sudo apt install vlc -y

# installing msttcorefonts
# 02/06/2022 - added DEBIAN_FRONTEND=noninteractive because I saw a Y/N font prompt on a system I'd stepped away from
echo "Installing msttcorefonts"
sudo DEBIAN_FRONTEND=noninteractive apt install msttcorefonts -y

# installing gstreamer1.0-plugins-ugly
echo "Installing gstreamer1.0-plugins-ugly"
sudo apt install gstreamer1.0-plugins-ugly -y

# install plugins to allow parole to play movie DVDs
sudo apt install gstreamer1.0-plugins-bad* -y

# Remove tuxpaint 08/15/2022
# installing tuxpaint
# echo "Installing tuxpaint"
#sudo apt install tuxpaint -y

# installing DVD decryption software
echo "Installing libdvd-pkg"
sudo DEBIAN_FRONTEND=noninteractive apt install libdvd-pkg -y
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure libdvd-pkg

# installing Inkscape
echo "Installing Inkscape & gtk-vector-screenshot"
sudo apt install inkscape gtk-vector-screenshot -y

# installing handbrake and winff
echo "Installing handbrake and winff"
sudo apt install handbrake winff -y

# installing games
# added icebreaker 10/27/2021
echo "Installing a bunch of games"
sudo apt install lbreakout2 freedroid frozen-bubble kobodeluxe aisleriot gnome-mahjongg pysolfc icebreaker supertux mrrescue sdlpop marsshooter caveexpress -y

# installing hydrogen drum kit and kits
echo "Installing Hydrogen"
sudo apt install hydrogen hydrogen-drumkits -y

# install audacity
echo "Installing audacity"
sudo apt install audacity -y

# install neofetch
sudo apt install neofetch -y

# install hardinfo cpu-x
sudo apt install hardinfo cpu-x -y

# install more screensavers!
sudo apt install xscreensaver-data-extra -y

# install putty for terminal SSH hackers
sudo apt install putty -y

# install gnome-disk-utility
sudo apt install gnome-disk-utility -y

# install tools to read MacOS formatted drives
sudo apt install hfsprogs hfsplus hfsutils -y

# set up the sensors
sensors=$(dpkg -s lm-sensors | grep Status)
if [ ! "$sensors" == "Status: install ok installed" ]
	then
		echo "Installing lm-sensors"
		sudo apt install lm-sensors -y
		sudo sensors-detect
		sensors > /home/$USER/Desktop/sensors.txt
	else
		echo "Lm-sensors is already installed."
fi

# This setting applies to Xubuntu 22.04 only
# set VLC to be the default DVD player since parole doesn't play in Ubuntu 22.04
distro=$(cat /etc/lsb-release | grep CODENAME)

if [ $distro == 'DISTRIB_CODENAME=jammy' ] || [ $distro == "noble" ]
	then
		xfconf-query -c thunar-volman -p /autoplay-video-cds/command -s 'vlc dvd://'
		echo 'Default DVD player set to VLC'	
	else
		echo 'Focal'
fi

# check if this appears to be a laptop and if so install tlp and powertop
if [ -d "/proc/acpi/button/lid" ]; then
	sudo apt install tlp powertop-1.13 -y
	sudo service enable tlp
fi

# remove the old deb files
cd $currentdir

if [ $distro == 'DISTRIB_CODENAME=jammy' ] || [ $distro == 'DISTRIB_CODENAME=focal' ] || [ $distro == "noble" ]
	then
		rm onlyoffice.deb zoom.deb phoronix.deb adobe.deb
	else
		rm phoronix.deb
fi
