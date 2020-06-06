#!/bin/bash
#
# this is meant to be sourced by backup.sh and will use variables defined there
#
# prunes old backups

echo "$(date +'%Y-%m-%d %H:%M') - BORG_PRUNE: pruning old backups"
borg prune ${BACKUP_OPTS_RETENTION} ${BACKUP_REPO}
echo "$(date +'%Y-%m-%d %H:%M') - BORG_PRUNE: pruning complete"
