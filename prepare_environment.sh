#!/bin/bash
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

#
# TODO: Is QtCreator installation required ?
#

sudo steamos-readonly disable
sudo steamos-readonly status
# We delete keys because after SteamOS update, pacman-key --init does not work.
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --populate holo
echo "y" | sudo pacman -Scc
sudo pacman -S --noconfirm --overwrite \* fakeroot
sudo pacman -Sy --noconfirm base-devel
sudo pacman -Sy --noconfirm archlinux-keyring autoconf automake binutils bison debugedit fakeroot file findutils flex gawk gcc gettext grep groff gzip libtool m4 make pacman patch pkgconf sed sudo which glibc hwinfo linux-api-headers qt5-base cmake jsoncpp libuv rhash glibc linux-neptune-headers
sudo pacman -Sy --noconfirm qt6-base qt6-5compat qt6-declarative qt6-multimedia qt6ct qt6-shadertools
sudo pacman -Sy --noconfirm mesa glu mesa-unstable mesa-utils mesa-vdpau lib32-mesa lib32-mesa-vdpau lib32-libglvnd libglvnd
sudo pacman -Sy --noconfirm lib32-mesa lib32-mesa-vdpau lib32-libglvnd libglvnd
sudo pacman -Syu --noconfirm glibc linux-api-headers
sudo steamos-readonly enable

ln -s $SCRIPTDIR/BetterGallery.desktop /home/deck/Desktop


#
# TODO: Add to Steam from Command Line Interface ??
#

# Add controller configuration
$SCRIPTDIR/controller_config_install.sh

chmod +x $SCRIPTDIR/build.sh
cd $SCRIPTDIR
$SCRIPTDIR/build.sh
