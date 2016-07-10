#!/bin/bash

# This is my own little script to install the dependencies to record a screen
# WARNING: Makes use of AUR, so only works on Arch distros
mkdir scr2gif
cd scr2gif
# Install xrectsel
git clone https://aur.archlinux.org/xrectsel.git
cd xrectsel
makepkg -sri
cd ..
# Install ffcast
git clone https://aur.archlinux.org/ffcast.git
cd ffcast
makepkg -sri
cd ..
