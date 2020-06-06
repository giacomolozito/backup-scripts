#!/bin/bash
#
# this is meant to be sourced by backup.sh and will use variables defined there
#
# send the backup repository to the NAS via FTP
# (note: this users lftp, rsync is a lot better if your NAS supports it)

log "NAS_SEND" "archiving backup before sending to NAS"
rm -f ${BACKUP_ROOT}/archive.tar
tar cf ${BACKUP_ROOT}/archive.tar ${BACKUP_REPO}

log "NAS_SEND" "sending archive.tar to NAS via FTP"
lftp ${BACKUP_NAS_HOST} << EOF
set ftp:ssl-force true
${BACKUP_NAS_LFTPEXTRAOPTS}
user ${BACKUP_NAS_USER} ${BACKUP_NAS_PASS}
mkdir -fp ${BACKUP_NAS_PATH}
cd ${BACKUP_NAS_PATH}
put ${BACKUP_ROOT}/archive.tar
bye
EOF

rm -f ${BACKUP_ROOT}/archive.tar
log "NAS_SEND" "archive sent to NAS"
