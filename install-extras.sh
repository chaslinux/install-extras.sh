#!/bin/bash
# Script by Charles McColm, cr@theworkingcentre.org
# for The Working Centre's Computer Recycling Project
# Installs a bunch of extra software that's useful for our
# Xubuntu 20.04 installs
# Just run as ./install-extras.sh, don't run as sudo ./install-extras.sh
#
# Update 03/09/2022 - Added MS Office 265 web desktop apps, chromium, and freac
# I'd like to make freac the default cd media player in the near future

# Run updates first as some software may not install unless the system is
# updated
sudo apt update && sudo apt -y upgrade

# install Microsoft Office 365 web apps
sudo snap install --beta office365webdesktop

# install chromium web browser
sudo snap install chromium

# install freac for audio CD playback and ripping
sudo snap install freac

# install htop, mc, curl, git and build-essential because they're awesome tools
sudo apt -y install htop mc curl git build-essential

# install Timeshift for system backups
echo "Installing Timeshift, Stacer, Steam and MS TTF Fonts"
sudo apt -y install timeshift stacer steam ttf-mscorefonts-installer geany

# Install OnlyOffice 7.0 since it looks a bit closer to MS Office
wget https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
sudo dpkg -i onlyoffice-desktopeditors_amd64.deb
sudo apt -y --fix-broken install 

# install Zoom for conferencing
echo "Installing Zoom"
wget https://zoom.us/client/latest/zoom_amd64.deb
sudo dpkg -i zoom_amd64.deb
sudo apt -y --fix-broken install

# install cheese
echo "Installing Cheese"
sudo apt -y install cheese

# installing stacer
echo "Installing Stacer"
sudo apt -y install stacer

# installing VLC
echo "Installing VLC"
sudo apt -y install vlc

# installing msttcorefonts
echo "Installing msttcorefonts"
sudo apt -y install msttcorefonts

# installing gstreamer1.0-plugins-ugly
echo "Installing gstreamer1.0-plugins-ugly"
sudo apt -y install gstreamer1.0-plugins-ugly

# installing tuxpaint
echo "Installing tuxpaint"
sudo apt -y install tuxpaint

# installing DVD decryption software
echo "Installing libdvd-pkg"
sudo apt -y install libdvd-pkg
sudo dpkg-reconfigure libdvd-pkg

# installing Inkscape
echo "Installing Inkscape"
sudo apt -y install inkscape

# installing aptitude
echo "Installing aptitude"
sudo apt -y install aptitude

# installing handbrake and winff
echo "Installing handbrake and winff"
sudo apt -y install handbrake winff

# installing games
# added icebreaker 10/27/2021
echo "Installing a bunch of games"
sudo apt -y install lbreakout2 freedroid frozen-bubble lincity-ng kobodeluxe aisleriot gnome-mahjongg pysolfc icebreaker supertux

# installing hydrogen drum kit and kits
echo "Installing Hydrogen"
sudo apt -y install hydrogen hydrogen-drumkits

# install audacity
echo "Installing audacity"
sudo apt -y install audacity

# install neofetch
sudo apt -y install neofetch

# install phoronix-test-suite
wget http://phoronix-test-suite.com/releases/repo/pts.debian/files/phoronix-test-suite_10.6.1_all.deb
sudo dpkg -i phoronix-test-suite_10.6.1_all.deb
sudo apt -y --fix-broken install 

# install hardinfo
sudo apt -y install hardinfo

# install more screensavers!
sudo apt -y install xscreensaver-data-extra

# install putty for terminal SSH hackers
sudo apt -y install putty

# install gnome-disk-utility
sudo apt -y install gnome-disk-utility

# install an old version of Adobe Acrobat Reader in case user needs to read "secure" PDFs
sudo apt update
sudo dpkg --add-architecture i386
sudo apt -y install libxml2:i386 libcanberra-gtk-module:i386 gtk2-engines-murrine:i386 libatk-adaptor:i386
wget -O ~/adobe.deb http://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb
cd ~
sudo dpkg -i adobe.deb

# set up the sensors
echo "Installing lm-sensors"
sudo apt -y install lm-sensors
sudo sensors-detect
sensors > /home/$USER/Desktop/sensors.txt
