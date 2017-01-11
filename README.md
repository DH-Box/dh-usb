#About
DH-USB is an opinionated adaptation of Arch Linux, customized for use by digital humanists, data scientists, corpus linguists, and anyone else that works with text as data. This script will install DH-USB persistently to your USB drive, allowing you to run the operating system directly from the disk. The storage available to your system is limited only by the size of your USB drive. 

##Software Included
 - **Desktop Environment**: GNOME
 - **Programming Languages**: Python 3, Ruby 
 - **IDEs**: Jupyter, Jupyter Notebook, iPython
 - **Text Editors**: Vim, Gedit
 - **Web Browsing**: Chromium (open-source Google chrome)  
 - **Web Development**: Jekyll
 - **Document management**: Pandoc, pandoc-citeproc, pandoc-crossref
 - **Bibliographic Management**: Zotero

#Warning
This is a work-in-progress! Please do not use these scripts unless you know what you’re doing. 

#Prerequisites 
For this script to work, you must have: 

 - a large USB drive, maybe over 10GB. This hasn’t been tested with anything but a 32GB drive
 - a modern x86_64 system that supports UEFI. Legacy boot may be possible, but it hasn’t been tested. 
 - Antergos Linux, or Arch Linux with the Antergos repositories in /etc/pacman.conf 
 - the Arch Linux package `arch-install-scripts`
 - for this to boot on a Mac, we also need the Arch package `hfsprogs` and the AUR package `mactel-boot`. 

#Usage
Figure out what device label your USB drive has with `sudo fdisk -l`. If it’s `/dev/sdb`, you don’t need to configure anything, but if it’s something else, like `/dev/sdc`, you’ll need to edit the script first. Once you’re absolutely sure that your disk label is correct, you can run this command, which will erase and partition your disk, install Arch and all the other software, and configure everything: 

    sudo ./install.sh all

If you just want to perform one of those tasks, try something like

    sudo ./install.sh files

Make sure to read the script first so that you know what’s happening. This script is not intended for widespread usage, so bad things can happen to your system if you use it incorrectly. 
