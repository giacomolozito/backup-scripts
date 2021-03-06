#!/bin/bash
#
# this is meant to be sourced by backup.sh and will use variables defined there
#
# send the backup repository to the NAS via FTP
# (note: this users lftp, rsync is a lot better if your NAS supports it)

# only execute if no errors were encountered
if [ $BACKUP_RESULT -gt 1 ]; then
  log "NAS_SEND_FTP" "skipping NAS send due to earlier errors"
  return
fi

log "NAS_SEND_FTP" "archiving backup before sending to NAS"
rm -f ${BACKUP_ROOT}/archive.tar
tar cf ${BACKUP_ROOT}/archive.tar ${BACKUP_REPO}
if [ $? != 0 ]; then
  set_backup_result 1
fi

log "NAS_SEND_FTP" "sending archive.tar to NAS via FTP"
lftp ${BACKUP_NAS_FTP_HOST} << EOF
set ftp:ssl-force true
${BACKUP_NAS_FTP_LFTPEXTRACMD}
user ${BACKUP_NAS_FTP_USER} ${BACKUP_NAS_FTP_PASS}
mkdir -fp ${BACKUP_NAS_FTP_PATH}
cd ${BACKUP_NAS_FTP_PATH}
put ${BACKUP_ROOT}/archive.tar
bye
EOF
if [ $? != 0 ]; then
  set_backup_result 1
fi

rm -f ${BACKUP_ROOT}/archive.tar
log "NAS_SEND_FTP" "archive sent to NAS"
