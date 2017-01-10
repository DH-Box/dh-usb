#!/bin/bash

# This file is not meant to be run by the user, but should be run
# by the install script, chrooted into the USB system. 

# Adapted from this Antergos script: 
# https://github.com/Antergos/antergos-iso/blob/2e202f41404fd9b010559320031014fc80b462e2/configs/kde/root-image/etc/lightdm/Xsession#L77

echo 'Setting GNOME settings.'

# Make sure dbus is available then set gsettings
export DISPLAY=:0

if [[ -z "$DBUS_SESSION_BUS_ADDRESS" ]]; then
	# No DBUS session running, start one.
	eval `dbus-launch --sh-syntax`
fi

# Change keyboard layaout
_current_val="$(gsettings get org.gnome.desktop.input-sources sources)"
echo "${_current_val}" > /tmp/.input-sources
if [[ *'[]'* = "${_current_val}" ]]; then
	gsettings set org.gnome.desktop.input-sources sources "[('xkb','us')]"
fi

# Enabled extensions
_extensions="['user-theme@gnome-shell-extensions.gcampax.github.com', 'status-menu-buttons@dev.antergos.com', 'dash-to-dock@micxgx.gmail.com', 'panel-osd@berend.de.schouwer.gmail.com', 'topIcons@adel.gadllah@gmail.com']"
gsettings set org.gnome.shell enabled-extensions "${_extensions}"

# Extension - Panel-OSD Settings
gsettings set org.gnome.shell.extensions.panel-osd x-pos 96.0
gsettings set org.gnome.shell.extensions.panel-osd y-pos 96.0
gsettings set org.gnome.shell.extensions.panel-osd force-expand true

# Extension - dash-to-dock Settings
gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme false
gsettings set org.gnome.shell.extensions.dash-to-dock opaque-background true
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.5
gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-running-dots false
gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-shrink false

# Set favorite apps
gsettings set org.gnome.shell favorite-apps "['org.gnome.Terminal.desktop', 'chromium.desktop', 'org.gnome.Nautilus.desktop']"

# Disable screensaver
#gsettings set org.gnome.desktop.screensaver lock-enabled false
#gsettings set org.gnome.desktop.lockdown disable-lock-screen true
#gsettings set org.gnome.desktop.session idle-delay 0

# Set theme
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark'
gsettings set org.gnome.desktop.wm.preferences theme 'Arc-Dark'
gsettings set org.gnome.shell.extensions.user-theme name 'Arc-Dark'

# Set icon theme
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

# Don't show desktop icons
gsettings set org.gnome.desktop.background show-desktop-icons false

# Minimize and close buttons
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

# Don't Disable terminal bell (accessibility concerns)
#gsettings set org.gnome.desktop.wm.preferences audible-bell true

# Configure touchpad
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
#gsettings set org.gnome.desktop.peripherals.touchpad scroll-method 'two-finger-scrolling'

# Set fonts
#gsettings set org.gnome.desktop.interface font-name 'Open Sans 12'
#gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Open Sans 13'
#gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'

# Turn on automatic date/time
gsettings set org.gnome.desktop.datetime automatic-timezone true

echo 'Finished setting GNOME settings.'
