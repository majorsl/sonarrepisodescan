#!/bin/bash
# version 1.7.0 *See README.md for requirements and help*
# SET YOUR OPTIONS HERE -------------------------------------------------------------------------
# your API key, single line in a txt file.
SONARRAPI="/home/majorsl/Scripts/sonarrapi.txt"
# your Sonarr's IP/hostname address, single line in a txt file eg 10.0.1.2 or example.com
SONARRIP="/home/majorsl/Scripts/sonarrip.txt"
# path relative to this script of new files to process.
INBOX="/storagedrive/Downloads/Sonarr/"
# path relative to this script where processed files are moved for Sonarr processing.
OUTBOX="/synology/mediacenter/Unsorted-TV Shows/"
# path relative to your Sonarr install where it will find the files.
SONARRBOX="/tv/Unsorted-TV Shows/"
# number of days to clean up stale items in the OUTBOX.
CLEAN="10"
# -----------------------------------------------------------------------------------------------
IFS=$'\n'

# verify path exist, exit if not.
if [ ! -d "$INBOX" ]; then
	echo "$INBOX Not Found!"
	exit 1
fi

# read api key & host.
APIKEY=$(cat "$SONARRAPI")
IP=$(cat "$SONARRIP")

# base URL for your Sonarr's api.
BASEURL="http://$IP:8989/api/v3/command"

# clean up these files so they don't confuse Sonarr.
filearray=( '*.exe' '*.nfo' '.DS_Store' '*.srt' '*.sfv' '*.jpg' '*.idx' '*.md5' '*.url' '*.mta' '*.txt' '*.png' '*.ico' '*.xml' '*.htm' '.html' '*.web' '*.lnk' '*.website' '*.torrent' '*.sql' '*.sql-lite' '*.sqlite' 'Thumbs.db' '*.json' )
for delfile in "${filearray[@]}"
do
	find "$INBOX" -iname "$delfile" -delete
done

# delete files smaller than xMB since these are often un-named sample files.
filearray3=( '*.mp4' '*.mkv' '*.avi' )
for delfile in "${filearray3[@]}"
do
	find "$INBOX" -maxdepth 4 -type f -size -15M -iname "$delfile" -delete
done

# move single files into folders which Sonarr requires.
#shopt -s nullglob
for FILE in "$INBOX"/*; do
    if [[ -f "$FILE" ]]; then
        BASE=${FILE%.*}
        JOB="${BASE}.job"
            if [[ ! -d "$JOB" ]]; then
                mkdir "$JOB"
            fi
        mv "$FILE" "$JOB"
    fi
done

# Move files.
mv $INBOX* $OUTBOX

# tell Sonarr to scan for episodes.
cd "$OUTBOX" || exit

#Set condition so first directory is skipped since it is "."
I="1"
for EPISODE in $(find . -type d); do
	if [[ "$I" -ne "1" ]]; then
		echo "$EPISODE"
        /usr/bin/curl --max-time 240 $BASEURL -X POST --header "X-Api-Key:$APIKEY" -d "{\"name\":\"DownloadedEpisodesScan\",\"path\":\"$SONARRBOX$EPISODE\",\"importMode\":\"Move\"}" --header "Content-Type: application/json; charset=utf-8"
    fi
    I="2"
done

# Clean stale files.
cd "$OUTBOX" || exit
find . -name "*.*" -type f -mtime +$CLEAN -delete
cd "$INBOX" || exit
find . -name "*.*" -type f -mtime +$CLEAN -delete

# Remove empty directories.
cd "$OUTBOX" || exit
find . -empty -type d -delete
cd "$INBOX" || exit
find . -empty -type d -delete
