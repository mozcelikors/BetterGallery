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
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Sy --noconfirm --needed base-devel
sudo pacman -Sy --noconfirm --needed archlinux-keyring autoconf automake binutils bison debugedit fakeroot file findutils flex gawk gcc gettext grep groff gzip libtool m4 make pacman patch pkgconf sed sudo which
sudo pacman -Sy --noconfirm --needed glibc hwinfo linux-api-headers qt5-base cmake
sudo pacman -Sy --noconfirm --needed cmake jsoncpp libuv rhash qt6-base qt6-5compat qt6-declarative qt6-multimedia qt6ct qt6-shadertools
sudo pacman -Sy --noconfirm --needed lib32-libglvnd libglvnd lib32-mesa
sudo pacman -Sy --noconfirm --needed glibc
sudo pacman -Sy --noconfirm --needed linux-api-headers linux-neptune-headers
sudo steamos-readonly enable


ln -s $SCRIPTDIR/BetterGallery.desktop /home/deck/Desktop


#
# TODO: Add to Steam from Command Line Interface ??
#

#
# TODO: Add Controller Configuration via Script ??
#

chmod +x $SCRIPTDIR/build.sh
cd $SCRIPTDIR
$SCRIPTDIR/build.sh
