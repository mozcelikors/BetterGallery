#!/bin/bash

#
#  @author mozcelikors
#

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

ifs_backup=$IFS
IFS=$(echo -en "\n\b")

if [ -z "${STEAMUSERID}" ]; then
    echo "STEAMUSERID is unset or set to the empty string. Please set this as environment variable next time."
    STEAMUSERID=68460212
fi

STEAMAPPSDIR=/home/deck/.local/share/Steam/steamapps/
SCREENSHOTSDIR=/home/deck/.local/share/Steam/userdata/$STEAMUSERID/760/remote
ids=($(ls /home/deck/.local/share/Steam/userdata/$STEAMUSERID/760/remote)) # -> IDS
names=($(ls /home/deck/.local/share/Steam/userdata/$STEAMUSERID/760/remote)) # -> Names

list_screenshots_per_gameid(){
    ls -t $SCREENSHOTSDIR/$1/screenshots/*jpg
}

rm $SCRIPTDIR/out/names.txt
rm $SCRIPTDIR/out/ids.txt
rm -rf $SCRIPTDIR/out/bettergallery_gamedata
mkdir -p $SCRIPTDIR/out/bettergallery_gamedata/
mkdir -p $SCRIPTDIR/out/bettergallery_headers


#Download game headers
for ((i=0; i < ${#ids[@]}; i++))
do
    wget -nc -O $SCRIPTDIR/out/bettergallery_headers/${ids[$i]}.jpg https://steamcdn-a.akamaihd.net/steam/apps/${ids[$i]}/header.jpg
done

# Create ids.txt
for ((i=0; i < ${#ids[@]}; i++))
do
    echo "${ids[$i]}" >> $SCRIPTDIR/out/ids.txt
    list_screenshots_per_gameid ${ids[$i]} > $SCRIPTDIR/out/bettergallery_gamedata/${ids[$i]}.txt
    # Delete empty lines
    sed -i '/^$/d' $SCRIPTDIR/out/bettergallery_gamedata/${ids[$i]}.txt
done

# Clear previous sorted names and ids
rm $SCRIPTDIR/out/ids_sorted.txt
rm $SCRIPTDIR/out/names_sorted.txt

#Download game names
wget -nc -O $SCRIPTDIR/out/gamenames.json http://api.steampowered.com/ISteamApps/GetAppList/v0002/
cat $SCRIPTDIR/out/gamenames.json | python -m json.tool > $SCRIPTDIR/out/gamenames_pretty.json

# Get game names and construct names.txt
export BETTERGALLERYDIR=$SCRIPTDIR
cat $SCRIPTDIR/out/gamenames.json | python3 $SCRIPTDIR/load_game_names.py

IFS=$ifs_backup
