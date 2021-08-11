#!/bin/bash
title=$(youtube-dl -f mp4 -o '%(id)s.%(ext)s' --print-json --no-warnings "$1" | jq -r .title)
oputput=( $(youtube-dl -g $1) )
liveLinks=()
for i in "${!oputput[@]}"; do
    liveLinks=( $(echo ${oputput[$i]} | grep yt_live_broadcast) )
    if [ ${#liveLinks[@]} -gt 0 ]
    then
        break
    fi
done
linkeType=""
finalLink=""
if [ ${#liveLinks[@]} -gt 0 ]
then
    linkeType="Live Stream"
    finalLink=${liveLinks[0]}
else
    if [ ${#oputput[@]} -gt 1 ]
    then
        linkeType="Static Stream"
        for i in "${!oputput[@]}"; do
            #echo ${oputput[$i]}
            finalLink=$(echo ${oputput[$i]} | grep "mime=audio")
            if [ ! -z "$finalLink" ]
            then
                break
            fi
        done
    else
        finalLink=${oputput[0]}
    fi
fi
if [ ! -z "$finalLink" ]
then
    echo "Starting Audio ${linkeType} of ${title}:"
    ffplay -nostats -loglevel 0 -nodisp -i  ${finalLink}
fi
