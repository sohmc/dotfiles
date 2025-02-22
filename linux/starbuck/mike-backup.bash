#!/bin/bash

# -- CONFIGURATION --
DOM=$(date +%d)
BACKUP_NAME=home-mike
SOURCE_DIR=/home/mike
DESTINATION_DIR=/viper/mike


LEVEL=$(tail -n 1 $HOME/.cache/${BACKUP_NAME}-backup.log| sed -r 's/.*level([0-9]+).*/\1/')

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
  -n $BACKUP_NAME -s $DESTINATION_DIR \
  -l $LEVEL $SOURCE_DIR

if [ "$?" != 0 ]; then
  echo -e "$(date +"%Y/%m/%d %T") Backup script errored: $?"
  exit $?
fi


LATEST_BACKUP_FILE=$(ls -Art ${DESTINATION_DIR}/${BACKUP_NAME}* | tail -n 1)
BACKUP_SNAPDATE=$(date +%Y-%m-%d)

echo -e "$(date +"%Y/%m/%d %T") Uploading ${LATEST_BACKUP_FILE} to AWS S3"
echo -e "$(date +"%Y/%m/%d %T") Tags: backup-ring=0&backup-snapdate=${BACKUP_SNAPDATE}&backup-dir=${USER}@${HOSTNAME}:${SOURCE_DIR}&backup-hostname=${HOSTNAME}"

rclone copy -vv --s3-no-check-bucket \
  --header-upload "x-amz-tagging: backup-ring=0&backup-snapdate=${BACKUP_SNAPDATE}&backup-dir=${USER}@${HOSTNAME}:${SOURCE_DIR}&backup-hostname=${HOSTNAME}" \
  $LATEST_BACKUP_FILE home-mike:/${HOSTNAME}

if [ "$?" != 0 ]; then
  echo -e "rclone errored: $?"
  exit $?
fi


LATEST_BACKUP_FILE=$(ls -Art ${DESTINATION_DIR}/${BACKUP_NAME}* | tail -n 1)
echo -e "${LATEST_BACKUP_FILE}" >> $HOME/.cache/mike-backup.log
