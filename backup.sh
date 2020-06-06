#!/bin/bash
#
# Giacomo.Lozito
# simple backup script with borg backup

BACKUP_ROOT=/backup
BACKUP_REPO=${BACKUP_ROOT}/repo
BACKUP_TOOLSDIR=${BACKUP_ROOT}/borg-scripts
BACKUP_LOG=${BACKUP_TOOLSDIR}/backup.log
BACKUP_CFG=${BACKUP_TOOLSDIR}/backup.sh.cfg

# redirect standard output and eVrror to log
touch ${BACKUP_LOG}
exec 1>>${BACKUP_LOG}
exec 2>&1

echo "---"
echo "Backup started at $(date)"

# add backup_config
if [ -f "${BACKUP_CFG}" ]; then
  source ${BACKUP_CFG}
else
  echo "Config file ${BACKUP_CFG} not found. Exiting."
  exit 1
fi

# run pre scripts, if present and set as executable
for f in ${BACKUP_TOOLSDIR}/scripts/pre_*; do
  if [[ -x "$f" ]]; then
    source $f
  fi
done

# run backup
DATE_TODAY=$(date +'%Y-%m-%d')
borg create ${BACKUP_OPTS} ${BACKUP_REPO}::${DATE_TODAY} ${BACKUP_TARGETS}

# run post scripts, if present and set as executable
for f in ${BACKUP_TOOLSDIR}/scripts/post_*; do
  if [[ -x "$f" ]]; then
    source $f
  fi
done

