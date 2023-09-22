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
#STEAMUSERID=68460212 #should come from outside
STEAMAPPSDIR=/home/deck/.local/share/Steam/steamapps/
SCREENSHOTSDIR=/home/deck/.local/share/Steam/userdata/$STEAMUSERID/760/remote
ids=($(ls $STEAMAPPSDIR/*.acf | cut -d "_" -f 2 | cut -d "." -f 1)) # -> IDS
names=($(ls $STEAMAPPSDIR/*.acf | xargs cat | grep "name" | cut -d '"' -f 4)) # -> Names

get_name_from_id () {
    idx=0
    for str in ${ids[@]}; do
        if [ $1 == $str ]; then
            break
        fi
        idx=$((idx+1))
    done
    echo ${names[$idx]}
}

get_id_from_name () {
    idx=0
    for str in ${names[@]}; do
        if [ $1 == $str ]; then
            break
        fi
        idx=$((idx+1))
    done
    echo ${ids[$idx]}
}

list_screenshots_per_gameid(){
    ls -t $SCREENSHOTSDIR/$1/screenshots/*jpg
}

list_screenshots_per_gamename(){
    id=`get_id_from_name $1`
    ls -t $SCREENSHOTSDIR/$id/screenshots/*jpg
}


rm $SCRIPTDIR/out/names.txt
rm $SCRIPTDIR/out/ids.txt
rm -rf $SCRIPTDIR/out/bettergallery_gamedata
mkdir -p $SCRIPTDIR/out/bettergallery_gamedata/

for ((i=0; i < ${#names[@]}; i++))
do
    echo "${names[$i]}" >> $SCRIPTDIR/out/names.txt
done

for ((i=0; i < ${#ids[@]}; i++))
do
    echo "${ids[$i]}" >> $SCRIPTDIR/out/ids.txt
    list_screenshots_per_gameid ${ids[$i]} > $SCRIPTDIR/out/bettergallery_gamedata/${ids[$i]}.txt
done


#Usage examples
#myvar=`get_name_from_id 236430`
#echo $myvar

#get_name_from_id 374320

#get_id_from_name "DARK SOULS™ II"

#list_screenshots_per_gameid `get_id_from_name "DARK SOULS™ II"`
#list_screenshots_per_gamename "DARK SOULS™ II"


IFS=$ifs_backup
