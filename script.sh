#!/usr/bin/env bash

# VARIABLES #

apt_apps=(
  git
  flameshot
  gnome-tweaks
  nautilus-dropbox
  neofetch
  mpv # for Anki audio
  shellcheck
  # gnome-session gdm3 # Vanilla Gnome
  # GitKraken, NetBrains Toolbox, Marktext, AppImageLauncher
  # Shell Themes Extension, Yaru Colors
)
apt_apps_desktop_only=(
  steam-installer
  piper
)

flatpak_apps=(
  com.spotify.Client # non-official
  com.discordapp.Discord # non-official
  org.libreoffice.LibreOffice # non-official
)
flatpak_apps_desktop_only=(
)

# TESTS #


# FUNCTIONS #

function merge_lists() {
  if [ "$1" -eq 1 ]; then
  for app in "${apt_apps_desktop_only[@]}"; do
    apt_apps+=("$app")
  done
  for app in "${flatpak_apps_desktop_only[@]}"; do
    flatpak_apps+=("$app")
  done
  fi
}

function update_everything {
  sudo apt update -y
  sudo apt upgrade -y
  flatpak update -y
}

function update_repos_and_apps {
  sudo apt update -y 
  flatpak update -y
}

function install_apps {
  for app in "${apt_apps[@]}"; do
    if ! sudo apt list --installed | grep -q "$app"; then
      sudo apt install "$app" -y -q
      echo ""
      echo "$app was installed"
      echo ""
    else
      echo ""
      echo "$app was already installed"
      echo ""
    fi
  done
  for app in "${flatpak_apps[@]}"; do
    if ! flatpak list | grep -q "$app"; then
      flatpak install flathub "$app" -y --noninteractive
      echo ""
      echo "$app was installed"
      echo ""
    else
      echo ""
      echo "$app was already installed"
      echo ""
    fi
  done
}

function install_lutris() {
  if [ "$1" -eq 1 ]; then
    sudo add-apt-repository ppa:lutris-team/lutris
    sudo apt update
    sudo apt install lutris
  fi
}

function reboot_if_desired() {
  if [ "$1" -eq 1 ]; then
    sudo reboot
  fi
}

# EXECUTION #

read -rp "Welcome! Choose where you're at:
1. Desktop
2. Laptop

---------> " OPTION

merge_lists "$OPTION"

update_everything

# Flatpak
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# WineHQ
sudo dpkg --add-architecture i386 
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ groovy main'
sudo apt update
sudo apt install --install-recommends winehq-stable

# Lutris
install_lutris "$OPTION"

update_repos_and_apps

install_apps

# # Run Gnome config file
# sh ./components/gnome.sh

# # Clone GitHub projects
# sh ./components/clone_github_projects.sh

# # Install Arduino IDE
# sh ./components/arduino_ide.sh

update_everything

read -rp "Do you want to reboot now?
1. Yes
2. No

---------> "   OPTION1

reboot_if_desired "$OPTION1"
