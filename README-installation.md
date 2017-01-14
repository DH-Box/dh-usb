#About

[DH-USB](https://github.com/JonathanReeve/dh-usb) is an opinionated adaptation of Arch Linux, customized for use by digital humanists, data scientists, corpus linguists, and anyone else that works with text as data. It is a full Linux install, designed to run completely from a USB disk. The .img file in this directory is just a disk image that you can write to a 16G or larger USB disk. 

#Installation

To install this .img file to your USB disk, use a USB image writer. There are a lot of GUI utilities out there, for example: 

 - Linux: Use the GNOME Disks utility, running “Restore Disk Image.” 
 - Windows: Use [USBWriter](https://sourceforge.net/p/usbwriter/wiki/Documentation/) or equivalent. 
 - MacOS: Use [UNetbootin](https://unetbootin.github.io/). You can mostly follow the instructions from [this Ubuntu guide](https://www.ubuntu.com/download/desktop/create-a-usb-stick-on-macos), but select the option “IMG” instead of “ISO” from the dropdown menu. 
 
Alternatively, you can usually do this on the command line without installing additional software. The instructions below were adapted from the [Arch Linux USB installation guide](https://wiki.archlinux.org/index.php/USB_flash_installation_media):

 - Linux: First identify the name of your USB drive by running `sudo fdisk -l`. Then run the command `sudo dd bs=4M if=/path/to/dh-usb.img of=/dev/sdx status=progress && sync`, replacing `sdx` with the name of your drive, and `/path/to/dh-usb.img` with the path to the image file. 
 - MacOS: Identify the label of your USB drive with the command `diskutil list`. Then unmount the disk with `diskutil unmountDisk /dev/diskX`, replacing `diskX` with your drive name. Finally, run `sudo dd if=/path/to/dh-usb.img of=/dev/rdiskX bs=1m` again replacing `/path/to/dh-usb.img` with the path to the .img file, and `diskX` with the name of your disk.  

#Resizing

If you have a USB drive larger than 16G, and you want to take advantage of the larger size of your drive, you can resize the main `dh-usb` partition (partition 2) after writing it to the USB. Since MacOS and Windows aren’t very good at working with ext4 filesystems, this is best done from Linux, using a command-line utility like `parted` or a GUI tool like GParted.  
