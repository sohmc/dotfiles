#!/bin/bash

DOM=$(date +%d)
LEVEL=$(ls -Art /viper/mike/home-mike-* | tail -n 1 | sed -r 's/.*level([0-9]+).*/\1/')

# if level has a length of 0 then no file was detected
if [ ${#LEVEL} -eq 0 ]; then 
  echo -e "$(date +"%Y/%m/%d %T") No backup file detected."
  LEVEL=0
elif [ ${DOM} -eq 1 ]; then
  # If it's the first day of the month, then request a level 0 backup
  echo -e "$(date +"%Y/%m/%d %T") Day of the month: ${DOM}"
  LEVEL=0
else
  echo -e "$(date +"%Y/%m/%d %T") Latest Level: ${LEVEL}"
  LEVEL=$((LEVEL+1))
fi

echo -e "$(date +"%Y/%m/%d %T") Requesting Incremental Level ${LEVEL}"

# Uses https://github.com/sohmc/Backup-Script/
$HOME/.local/bin/backup \
  -n home-mike -s /viper/mike \
  -l $LEVEL /home/mike 

if [ "$?" != 0 ]; then
  echo -e "$(date +"%Y/%m/%d %T") Backup script exited: $?"
  exit $?
fi


LATEST_BACKUP_FILE=$(ls -Art /viper/mike/home-mike* | tail -n 1)
BACKUP_SNAPDATE=$(date +%Y-%m-%d)

echo -e "$(date +"%Y/%m/%d %T") Uploading ${LATEST_BACKUP_FILE} to AWS S3"
echo -e "$(date +"%Y/%m/%d %T") Tags: backup-ring=0, backup-snapdate=${BACKUP_SNAPDATE}, backup-dir=mike@starbuck:/home/mike, backup-hostname=starbuck"

rclone copy -vv --s3-no-check-bucket \
  --header-upload "x-amz-tagging: backup-ring=0&backup-snapdate=${BACKUP_SNAPDATE}&backup-dir=mike@starbuck:/home/mike&backup-hostname=starbuck" \
  $LATEST_BACKUP_FILE home-mike:/starbuck

if [ "$?" = 0 ]; then
  echo -e "rclone exited: $?"
  exit $?
fi

