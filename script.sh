#!/usr/bin/env bash

# VARIABLES #

hostname_desktop="ubuntu-desktop"
hostname_laptop="ubuntu-laptop"

apt_apps=(
  git
  gnome-tweaks
  nautilus-dropbox
  neofetch
  mpv # for Anki audio
  shellcheck
)
apt_apps_desktop_only=(
  steam-installer
  piper
)

flatpak_apps=(
  com.spotify.Client # non-official
  com.discordapp.Discord # non-official
)
flatpak_apps_desktop_only=(
)

# Flatpak
sudo apt install flatpak
sudo add-apt-repository ppa:alexlarsson/flatpak
sudo apt update
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak

# WineHQ
sudo dpkg --add-architecture i386 
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ groovy main'
sudo apt update
sudo apt install --install-recommends winehq-stable

# Lutris
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt update
sudo apt install lutris