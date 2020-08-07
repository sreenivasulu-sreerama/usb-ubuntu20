#!/bin/bash

# Adjust environment
export PATH=$PATH:/sbin:/bin
locale-gen "en_US.UTF-8"

# Adjust sources list
cat >/etc/apt/sources.list <<EOF
deb file:/ubuntu focal main
deb http://security.ubuntu.com/ubuntu focal main universe
EOF

# Perform update
apt clean all
apt update

# Add packages
apt install --assume-yes accountsservice/focal
apt install --assume-yes build-essential/focal
apt install --assume-yes dnsutils/focal
apt install --assume-yes ssh/focal
apt install --assume-yes telnet/focal
apt install --assume-yes setserial/focal
apt install --assume-yes lsof/focal
apt install --assume-yes usbutils/focal
apt install --assume-yes ethtool/focal
apt install --assume-yes iptables/focal
apt install --assume-yes ebtables/focal
apt install --assume-yes gdisk/focal
apt install --assume-yes dmidecode/focal
apt install --assume-yes tcpdump/focal
apt install --assume-yes python/focal python-pycurl/focal python-serial/focal
apt install --assume-yes info/focal lshw/focal ntp/focal
apt install --assume-yes zip/focal unzip/focal
apt install --assume-yes software-properties-common/focal
apt install --assume-yes libqmi-utils/focal modemmanager/focal
sync

echo ""
echo "==========================================================="
echo " Installing Linux now. Select no disk when prompted to     "
echo " setup GRUB and exit without installing grub. The          "
echo " bootloader is setup later. Picking up incorrect disk      "
echo " may result in host system getting updated.                "
echo "==========================================================="
apt install --assume-yes linux-generic/focal
sync

# Install extra packages
if [ -d /extrapkgs ]; then
    apt install --assume-yes /extrapkgs/*.deb
fi

# Disable setserial service as it is changing serial port configuration
systemctl disable setserial

# Redo GRUB configuration
cat >/etc/default/grub <<EOF
# Customized GRUB configuration 
GRUB_DEFAULT=0
GRUB_TIMEOUT=2
GRUB_TIMEOUT_STYLE="menu"
GRUB_DISABLE_RECOVERY="true"
GRUB_DISABLE_SUBMENU="true"
GRUB_DISABLE_OS_PROBER="true"
GRUB_TERMINAL="serial"
GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"
GRUB_CMDLINE_LINUX_DEFAULT="crashkernel=auto panic=2 net.ifnames=0 console=ttyS0,115200n8"
EOF

# Generate grub config now
grub-mkconfig -o /boot/grub/grub.cfg

# Open up 'root' account for login and SSH
sed -i '/^root:/s/:x:/::/' /etc/passwd
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitEmptyPasswords .*/PermitEmptyPasswords yes/' /etc/ssh/sshd_config

exit 0
