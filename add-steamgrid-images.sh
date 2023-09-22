#!/bin/bash
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

rm -rf $SCRIPTDIR/out/
mkdir -p $SCRIPTDIR/out/
cd $SCRIPTDIR/out/
wget https://github.com/boppreh/steamgrid/releases/latest/download/steamgrid_linux.zip
unzip steamgrid_linux.zip
cd $SCRIPTDIR/out/steamgrid
cp $SCRIPTDIR/qtapplogo.png $SCRIPTDIR/out/games/BetterGallery.hero.png
cp $SCRIPTDIR/qtapplogo.png $SCRIPTDIR/out/games/BetterGallery.logo.png
cp $SCRIPTDIR/qtapplogo.png $SCRIPTDIR/out/games/BetterGallery.cover.png
cp $SCRIPTDIR/qtapplogo.png $SCRIPTDIR/out/games/BetterGallery.banner.png
chmod +x $SCRIPTDIR/out/steamgrid
echo "\r\n" | $SCRIPTDIR/out/steamgrid
