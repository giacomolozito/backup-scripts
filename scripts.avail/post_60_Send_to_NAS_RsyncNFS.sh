#!/bin/bash
#
# this is meant to be sourced by backup.sh and will use variables defined there
#
# send the backup repository to the NAS via rsync on a NFS share

# only execute if no errors were encountered
if [ $BACKUP_RESULT -gt 1 ]; then
  log "NAS_SEND_RNFS" "skipping NAS send due to earlier errors"
  return
fi

if [ "$BACKUP_NAS_RNFS_DOMOUNT" == "y" ]; then
  log "NAS_SEND_RNFS" "mounting NFS share for backups"
  mount -t nfs ${BACKUP_NAS_RNFS_HOST}:${BACKUP_NAS_RNFS_NFSPATH} ${BACKUP_NAS_RNFS_TARGET}
fi

log "NAS_SEND_RNFS" "syncing backup repo on NFS share via rysnc"
mkdir -p ${BACKUP_NAS_RNFS_TARGET}/$(hostname)
rsync -rt --delete ${BACKUP_REPO} ${BACKUP_NAS_RNFS_TARGET}/$(hostname) 
if [ $? != 0 ]; then
  log "NAS_SEND_RNFS" "failure on rsync execution"
  set_backup_result 1
else
  log "NAS_SEND_RNFS" "backup sync successful"
fi

if [ "$BACKUP_NAS_RNFS_DOMOUNT" == "y" ]; then
  log "NAS_SEND_RNFS" "unmounting NFS share for backups"
  umount ${BACKUP_NAS_RNFS_TARGET}
fi
