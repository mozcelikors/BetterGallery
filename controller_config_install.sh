#!/bin/bash

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

export STEAMUSERID=$(ls /home/deck/.local/share/Steam/userdata/)
if [ -z "${STEAMUSERID}" ]; then
    echo "STEAMUSERID is unset or set to the empty string. Please set this as environment variable next time."
    STEAMUSERID=68460212
fi
mkdir -p /home/deck/.local/share/Steam/steamapps/common/Steam\ Controller\ Configs/$STEAMUSERID/config/bettergallery
cp $SCRIPTDIR/controller_neptune.vdf /home/deck/.local/share/Steam/steamapps/common/Steam\ Controller\ Configs/$STEAMUSERID/config/bettergallery/controller_neptune.vdf
