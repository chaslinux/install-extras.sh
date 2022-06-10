#!/bin/bash
# Script by Charles McColm, cr@theworkingcentre.org
# for The Working Centre's Computer Recycling Project
# Installs a bunch of extra software that's useful for our
# Xubuntu 20.04, 22.04, and now Linux Mint Una
#
# Just run as ./install-extras.sh, don't run as sudo ./install-extras.sh
#
# Update 06/10/2022 - June update: added basic support for Linux Mint Una
# Update 04/22/2022 - Added line to set VLC as default player for DVDs on Ubuntu Jammy
# also shifted -y switch to the end of apt install programname since Linux Mint doesn't like
# it after apt install. Added plank for Xubuntu 22.04 with a customization based on the software
# installed here.
# Update 03/09/2022 - Added MS Office 265 web desktop apps, chromium, and freac
# I'd like to make freac the default cd media player in the near future

# set the current directory
currentdir=$(pwd)

# Run updates first as some software may not install unless the system is
# updated
sudo apt update && sudo apt upgrade -y

distro=$(cat /etc/lsb-release | grep CODENAME)
if [ $distro == 'DISTRIB_CODENAME=jammy' || $distro == 'DISTRIB_CODENAME=focal' ]
	then
        # install Microsoft Office 365 web apps
        sudo snap install --beta office365webdesktop;

        # install chromium web browser
        sudo snap install chromium;

        # install freac for audio CD playback and ripping
        sudo snap install freac;
        # Install OnlyOffice 7.0 since it looks a bit closer to MS Office
        onlyoffice=$(dpkg -s onlyoffice-desktopeditors | grep Status)
        if [ ! "$onlyoffice" == "Status: install ok installed" ]
        	then
        		wget -O onlyoffice.deb https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb;
        		sudo dpkg -i onlyoffice.deb;
        		sudo apt --fix-broken install -y;
        	else
        		echo "OnlyOffice is already installed";
        fi
        # install Zoom for conferencing
        zoom=$(dpkg -s zoom | grep Status)
        if [ ! "$zoom" == "Status: install ok installed" ]
	        then
		        echo "Installing Zoom";
		        wget -O zoom.deb https://zoom.us/client/latest/zoom_amd64.deb;
		        sudo dpkg -i zoom.deb;
		        sudo apt --fix-broken install -y;
	        else
		        echo "Zoom is already installed";
        fi

    else
        echo "Not a modern version of *buntu";
fi

# This applies to Linux Mint "Una" only (install most of the stuff above without snaps!)
if [ $distro == 'DISTRIB_CODENAME=una' ]
    then
        sudo apt install chromium -y;
        sudo flatpak update -y
        sudo flatpak install freac -y
        sudo flatpak install onlyoffice -y
        sudo flatpak install zoom -y
    else
        echo "Not Linux Mint Una";
fi


# install htop, mc, curl, git and build-essential because they're awesome tools
sudo apt install htop mc curl git build-essential -y

# install Timeshift for system backups
echo "Installing Timeshift, Stacer, Steam and MS TTF Fonts"
sudo apt install timeshift stacer steam ttf-mscorefonts-installer geany -y


# install cheese
echo "Installing Cheese"
sudo apt install cheese -y

# installing stacer
echo "Installing Stacer"
sudo apt install stacer -y

# installing VLC
echo "Installing VLC"
sudo apt install vlc -y

# installing msttcorefonts
echo "Installing msttcorefonts"
sudo apt install msttcorefonts -y

# installing gstreamer1.0-plugins-ugly
echo "Installing gstreamer1.0-plugins-ugly"
sudo apt install gstreamer1.0-plugins-ugly -y

# installing tuxpaint
echo "Installing tuxpaint"
sudo apt install tuxpaint -y

# installing DVD decryption software
echo "Installing libdvd-pkg"
sudo apt install libdvd-pkg -y
sudo dpkg-reconfigure libdvd-pkg

# installing Inkscape
echo "Installing Inkscape"
sudo apt install inkscape -y

# installing aptitude
echo "Installing aptitude"
sudo apt install aptitude -y

# installing handbrake and winff
echo "Installing handbrake and winff"
sudo apt install handbrake winff -y

# installing games
# added icebreaker 10/27/2021
echo "Installing a bunch of games"
sudo apt install lbreakout2 freedroid frozen-bubble lincity-ng kobodeluxe aisleriot gnome-mahjongg pysolfc icebreaker supertux -y

# installing hydrogen drum kit and kits
echo "Installing Hydrogen"
sudo apt install hydrogen hydrogen-drumkits -y

# install audacity
echo "Installing audacity"
sudo apt install audacity -y

# install neofetch
sudo apt install neofetch -y

# install phoronix-test-suite
phoronix=$(dpkg -s phoronix-test-suite | grep Status)
if [ ! "$phoronix" == "Status: install ok installed" ]
	then
		wget -O phoronix.deb http://phoronix-test-suite.com/releases/repo/pts.debian/files/phoronix-test-suite_10.6.1_all.deb;
		sudo dpkg -i phoronix.deb;
		sudo apt --fix-broken install -y;
	else
		echo "Phoronix-test-suite is already installed.";
fi

# install hardinfo
sudo apt install hardinfo -y

# install more screensavers!
sudo apt install xscreensaver-data-extra -y

# install putty for terminal SSH hackers
sudo apt install putty -y

# install gnome-disk-utility
sudo apt install gnome-disk-utility -y

# install an old version of Adobe Acrobat Reader in case user needs to read "secure" PDFs
adobe=$(dpkg -s adobereader-enu | grep Status)
if [ ! "$adobe" == "Status: install ok installed" ]
	then
		sudo apt update;
		sudo dpkg --add-architecture i386;
		sudo apt install libxml2:i386 libcanberra-gtk-module:i386 gtk2-engines-murrine:i386 libatk-adaptor:i386 -y;
		wget -O adobe.deb http://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb;
		sudo dpkg -i adobe.deb;
	else
		echo "Adobe Reader already installed.";
fi

# set up the sensors
sensors=$(dpkg -s lm-sensors | grep Status)
if [ ! "$sensors" == "Status: install ok installed" ]
	then
		echo "Installing lm-sensors";
		sudo apt install lm-sensors -y;
		sudo sensors-detect;
		sensors > /home/$USER/Desktop/sensors.txt;
	else
		echo "Lm-sensors is already installed.";
fi

# This setting applies to Xubuntu 22.04 only
# set VLC to be the default DVD player since parole doesn't play in Ubuntu 22.04
distro=$(cat /etc/lsb-release | grep CODENAME)

if [ $distro == 'DISTRIB_CODENAME=jammy' ]
	then
		xfconf-query -c thunar-volman -p /autoplay-video-cds/command -s 'vlc dvd://';
		echo 'Default DVD player set to VLC';	
		sudo apt install plank -y
		# copy our custom plank launcher to /etc/skel so other new users get planked correctly		
		sudo mkdir -p /etc/skel/.config/plank/dock1/launchers
		sudo cp $currentdir/plank-dock1.tar.gz /etc/skel/.config/plank/dock1/launchers
		cd /etc/skel/.config/plank/dock1/launchers
		sudo tar -zxvf plank-dock1.tar.gz
		# set up plank for the current user
		cd $currentdir
		mkdir -p ~/.config/plank/dock1/launchers
		cp $currentdir/plank-dock1.tar.gz ~/.config/plank/dock1/launchers
		cd ~/.config/plank/dock1/launchers
		tar -zxvf plank-dock1.tar.gz
		cd $currentdir
		plank &

		# Now make copy the plank .desktop file to autostart directories
		mkdir -p ~/.config/autostart
		cp $currentdir/plank.desktop ~/.config/autostart
		sudo cp $currentdir/plank.desktop /etc/xdg/autostart
else
		cd $currentdir
		rm plank-dock1.tar.gz
		echo 'Not focal';
fi


# remove the old deb files
cd $currentdir
rm onlyoffice.deb zoom.deb phoronix.deb adobe.deb

