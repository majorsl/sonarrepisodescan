#!/bin/bash
# version 1.0 *See README.md for requirements and help*

# base URL for your Sonarr's api.
BASEURL="https://synology.themajorshome.com:6003/api/command"
# your API key, single line in a txt file.
SONARRAPI="/Users/majorsl/Scripts/sonarrapi.txt"
# path relative to this script of new files to process.
INBOX="/Users/majorsl/Library/Containers/nz.co.pixeleyes.AutoMounter/Data/Mounts/synology/SMB/Media Center/Unsorted-TV Shows/"
# path relative to your Sonarr install where to find the files.
SONARRBOX="/volume1/Media Center/Unsorted-TV Shows/"
# pre-script path. Execute a script before sonarrepisodescan. Leave as "" if none.
PRESCRIPT="/Users/majorsl/Scripts/GitHub/convertac3/convertac3.sh"
# post-script path. Execute a script after sonarrepisodescan. Leave as "" if none.
POSTSCRIPT=""

IFS=$'\n'

# verify paths exist, exit if not.
if [ ! -d "$INBOX" ]; then
	echo "$INBOX Not Found!"
	exit 1
fi

# Execute pre-script.
if [ "$PRESCRIPT" != "" ]; then
	/bin/bash "$PRESCRIPT"
	wait
fi

# read api key.
APIKEY=$(cat "$SONARRAPI")

# clean up these files so they don't get moved to the show directories.
filearray=( '*.exe' '*.nfo' '.DS_Store' '*.srt' '*.sfv' '*.jpg' '*.idx' '*.md5' '*.url' '*.mta' '*.txt' '*.png' '*.ico' '*.xml' '*.htm' '.html' '*.web' '*.lnk' '*.website' '*.torrent' '*.sql' '*.sql-lite' '*.sqlite' 'Thumbs.db' '*.json' )
for delfile in "${filearray[@]}"
do
	find "$INBOX" -iname "$delfile" -delete
done

# delete files smaller than xMB since these are often un-named sample files.
filearray3=( '*.mp4' '*.mkv' '*.avi' )
for delfile in "${filearray3[@]}"
do
	find "$INBOX" -type f -maxdepth 4 -size -15M -iname "$delfile" -delete
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

# tell Sonarr to scan for episodes.
cd "$INBOX" || exit
#Set condition so first directory is skipped since it is "."
I="1"
for EPISODE in $(find . -type d); do
	if [[ "$I" -ne "1" ]]; then
		echo "$EPISODE"
        /usr/bin/curl $BASEURL -X POST \
        --header "Content-Type: Application/JSON" \
        --header "X-Api-Key: $APIKEY" \
        --data "{\"name\": \"DownloadedEpisodesScan\", \"path\": \"$SONARRBOX$EPISODE\"}";
    fi
    I="2"

# Execute post-script.
if [ "$POSTSCRIPT" != "" ]; then
	/bin/bash "$POSTSCRIPT"
	wait
fi
done
