#!/bin/bash

# Debugging mode. 
#set -x

# Stop on errors. 
set -e 

# Enter the label for your USB drive here. 
disk=/dev/sdb

dir=$PWD

sys="crda dialog gpm grml-zsh-config linux-atm lsscsi mc mtools ndisc6 nfs-utils grub nilfs-utils ntp rp-pppoe sg3_utils smartmontools speedtouch wvdial xl2tpd hdparm gptfdisk exfat-utils dmraid dosfstools gnu-netcat sdparm refind-efi f2fs-tools ntfs-3g testdisk partclone fsarchiver btrfs-progs parted ddrescue partimage wireless_tools wpa_actiond vpnc ppp pptpclient openconnect openssh openvpn dnsmasq dnsutils tcpdump lftp darkhttpd dhclient ethtool b43-fwcutter ipw2100-fw ipw2200-fw zd1211-firmware rsync rfkill usb_modeswitch mesa mesa-vdpau virtualbox-guest-modules-arch virtualbox-guest-utils xf86-input-synaptics xf86-video-ati xf86-video-fbdev xf86-video-intel xf86-video-nouveau xf86-video-openchrome xf86-video-vesa xf86-video-vmware xorg-server xorg-server-utils xorg-xinit xorg-xauth alsa-utils expect git pkgfile powerpill reflector sudo unzip unrar wget xdg-user-dirs-gtk yaourt fakeroot" 

fonts="divehi-fonts ttf-aboriginal-sans ttf-arphic-uming ttf-baekmuk ttf-bitstream-vera ttf-dejavu ttf-freefont ttf-opensans" 

desktop="gdm baobab chromium chromium-pepper-flash eog espeak evince file-roller gedit gnome-backgrounds gnome-bluetooth gnome-calculator gnome-common gnome-contacts gnome-control-center gnome-disk-utility gnome-documents gnome-keyring gnome-logs gnome-maps gnome-photos gnome-screenshot gnome-shell gnome-shell-extension-dash-to-dock gnome-shell-extensions gnome-sound-recorder gnome-system-monitor gnome-terminal gnome-themes-standard gnome-tweak-tool gnome-weather gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gstreamer0.10-plugins gstreamer-vaapi gvfs-mtp libgnomeui libwnck3 nautilus network-manager-applet totem transmission-cli transmission-gtk arc-gtk-theme gnome-software broadcom-wl" 

dh="vim python python-pip ruby jupyter jupyter-notebook python-nltk pandoc pandoc-citeproc pandoc-crossref mathjax" 

ruby_gems="jekyll"

aur="papirus-icon-theme-git zotero" 

desktop_files="jupter-notebook zotero" 

function partition() { 
	echo "Partitioning $disk!"
	parted $disk mktable gpt
	parted $disk mkpart primary fat32 1MiB 513MiB
	parted $disk set 1 boot on
	parted $disk mkpart primary ext4 513MiB 100%
	mkfs.ext4 -O "^has_journal" "$disk"2
	mkfs.fat -F32 "$disk"1
}

function mount { 
	echo "Mounting $disk"
	/usr/sbin/mount "$disk"2 /mnt 
	mkdir -p /mnt/boot 
	/usr/sbin/mount "$disk"1 /mnt/boot
} 

function unmount { 
	echo "Unmounting $disk"
	umount /mnt/boot
	umount /mnt
} 

function install { 
	echo "Installing system." 
	pacstrap /mnt base base-devel
	pacstrap /mnt $sys $fonts $desktop $dh
}

function config_init { 
	echo "Starting initial configuration of system." 
	arch-chroot /mnt ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

	# Copy /etc files
	for file in locale.gen locale.conf hostname fstab makepkg.conf
	do
		cp $file /mnt/etc/$file
		arch-chroot /mnt chown root:root /etc/$file
	done
		
	# Generate locale
	arch-chroot /mnt locale-gen

	# Set hardware clock
	arch-chroot /mnt hwclock --systohc

	# Generate boot image
	arch-chroot /mnt mkinitcpio -p linux

	# Install bootloader
	arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
	arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

	# Add default user
	arch-chroot /mnt useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /usr/bin/zsh dh-usb

	# Start services
	arch-chroot /mnt systemctl enable gdm
	arch-chroot /mnt systemctl enable NetworkManager
}


function install_extra {
	echo "Installing extra packages from the AUR" 
	# Install packages from AUR
	# It'd be great if this worked with `yaourt`,  but there are permissions
	# issues, so we have to do this the long way. 
	for package in $aur
	do
		sudo -u $SUDO_USER git clone https://aur.archlinux.org/$package.git /tmp/$package
		cd /tmp/$package
		sudo -u $SUDO_USER makepkg -src 
		pkgfile=`ls $package*.pkg.tar`
		mv /tmp/$package/$pkgfile /mnt/home/dh-usb/
		arch-chroot /mnt chown root:root /home/dh-usb/$pkgfile
		arch-chroot /mnt pacman -U --noconfirm /home/dh-usb/$pkgfile

		#Clean up
		cd $dir
		rm -rf /tmp/$package
		arch-chroot /mnt rm -rf /home/dh-usb/$pkgfile
	done

	# Install Ruby gems
	echo "Installing Ruby gems." 
	arch-chroot /mnt sudo -u dh-usb gem install -u $ruby_gems

	# TODO: Install Python modules
} 

function files { 
	# Copy dotfiles
	DEST=/home/dh-usb/
	for file in xinitrc zshrc setup.sh
	do 
		cp $file /mnt$DEST.$file
		arch-chroot /mnt chown dh-usb:users $DEST.$file 
	done

	# Give members of group Wheel access to sudo. 
	cp sudo /mnt/etc/sudoers.d/wheel
	arch-chroot /mnt chown root:root /etc/sudoers.d/wheel
	arch-chroot /mnt chmod -c 0440 /etc/sudoers.d/wheel

	# Copy over desktop files. 
	DEST=/home/dh-usb/.local/share/applications/
	arch-chroot /mnt sudo -u dh-usb mkdir -p $DEST
	for file in $desktop_files
	do 
		cp $file /mnt$DEST
		arch-chroot /mnt chown dh-usb:users $DEST$file
	done
}

function config_post { 
	# Run setup script on the USB system. 
	arch-chroot /mnt sudo -u dh-usb /home/dh-usb/.setup.sh
} 

function clean { 
	# Remove arguably unnecessarily desktop files so that the list of applications 
	# looks cleaner and more friendly.  
	for file in avahi-discover bssh bvnc qv4l2
	do 
		rm /mnt/usr/share/applications/$file.desktop
	done
} 

function install_r { 
	# Must be run first if you want to install R and associated packages. 
	dh="$dh r"
	aur="$aur rstudio-desktop-bin" 
	desktop_files="$desktop_files r rstudio"
} 

function all { 
	# install_r
	partition
	mount 
	install
	config_init
	install_extra
	files
	config_post
	clean
	unmount
}

$1
