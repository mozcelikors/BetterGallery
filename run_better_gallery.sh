#!/bin/bash
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

export STEAMUSERID=$(ls /home/deck/.local/share/Steam/userdata/)
systemd-cat echo "Running BetterGallery initialization script"
$SCRIPTDIR/init-prepare-game-lists.sh
systemd-cat echo "Running BetterGallery Qt app"
BETTERGALLERYDIR=$SCRIPTDIR $SCRIPTDIR/mediaplayer/build/mediaplayer
