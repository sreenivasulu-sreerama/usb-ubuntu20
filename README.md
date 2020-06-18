# usb-ubuntu20
Prepare a bootable USB stick from ubuntu server 20 ISO image

This script is used to prepare a USB stick with bootable
Ubuntu 20.04 LTS image. The bootable disk is prepared from Ubuntu
server install image. The host machine typically is a CentOS 7
system and is tested with a CentOS 7.6 host.

The script is not fully automated yet and the output is set to serial console. 

The script is tested with Ubuntu server 20.04 version downloaded
from:
https://releases.ubuntu.com/20.04/ubuntu-20.04-live-server-amd64.iso

This script can also be used to generate image suitable for running
in the VM.

GRUB installation:
=================
As part of installing Linux, GRUB will also be setup and the user will be prompted to
select the disk to install. Don't select any drive and exit GRUB setup without
installation. The GRUB bootloader will be setup by the script later. Picking up
build system as destination may result in GRUB of the build system getting updated
running the risk of the host system becoming non-bootable.

Usage:
=====
Usage: ./ubuntu-iso-to-disk [path-to-ubuntu-iso] [target-device OR disk-image-filename]\
   target-device is argument of format /dev/sd*\
   disk-image-filename is meant to be consumed by a VM

