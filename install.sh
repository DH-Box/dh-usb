#!/bin/bash

base="crda dialog gpm grml-zsh-config linux-atm lsscsi mc mtools ndisc6 nfs-utils grub nilfs-utils ntp rp-pppoe sg3_utils smartmontools speedtouch wvdial xl2tpd"

disk="hdparm gptfdisk exfat-utils dmraid dosfstools gnu-netcat sdparm refind-efi f2fs-tools ntfs-3g testdisk partclone fsarchiver btrfs-progs parted ddrescue partimage"

networking="wireless_tools wpa_actiond nmap vpnc ppp pptpclient openconnect clonezilla openssh openvpn dnsmasq dnsutils elinks tcpdump lftp darkhttpd dhclient ethtool irssi b43-fwcutter ipw2100-fw ipw2200-fw zd1211-firmware rsync"

drivers="rfkill usb_modeswitch mesa mesa-vdpau virtualbox-guest-modules-arch virtualbox-guest-utils xf86-input-synaptics xf86-video-ati xf86-video-fbdev xf86-video-intel xf86-video-nouveau xf86-video-openchrome xf86-video-vesa xf86-video-vmware xorg-server xorg-server-utils xorg-xinit xorg-xauth" 

system="alsa-utils expect git pkgfile powerpill reflector sudo unzip unrar wget xdg-user-dirs-gtk" 

fonts="divehi-fonts ttf-aboriginal-sans ttf-arphic-uming ttf-baekmuk ttf-bitstream-vera ttf-dejavu ttf-freefont ttf-opensans" 

desktop="gdm baobab chromium chromium-pepper-flash dconf-editor eog espeak evince file-roller gedit gnome-backgrounds gnome-bluetooth gnome-calculator gnome-common gnome-contacts gnome-control-center gnome-disk-utility gnome-documents gnome-keyring gnome-logs gnome-maps gnome-music gnome-photos gnome-screenshot gnome-shell gnome-shell-extension-dash-to-dock gnome-shell-extension-topicons gnome-shell-extension-status-menu-buttons gnome-shell-extension-panel-osd gnome-shell-extensions gnome-sound-recorder gnome-system-monitor gnome-terminal gnome-themes-standard gnome-tweak-tool gnome-weather gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gstreamer0.10-plugins gstreamer-vaapi gvfs-mtp libgnomeui libwnck3 nautilus network-manager-applet totem transmission-cli transmission-gtk" 

dh="vim python" 

function print() {
	echo $base
	echo $disk
}


