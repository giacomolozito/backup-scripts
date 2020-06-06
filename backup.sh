#!/bin/bash
#
# Giacomo.Lozito@gmail.com - simple backup script with borg backup
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#  
# This program is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#  
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


BACKUP_ROOT=/backup
BACKUP_REPO=${BACKUP_ROOT}/repo
BACKUP_TOOLSDIR=${BACKUP_ROOT}/borg-scripts
BACKUP_LOG=${BACKUP_TOOLSDIR}/backup.log
BACKUP_CFG=${BACKUP_TOOLSDIR}/backup.sh.cfg

# redirect standard output and error to log
touch ${BACKUP_LOG}
exec 1>>${BACKUP_LOG}
exec 2>&1

function log {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1: $2"
}

log "BACKUP" "script started"

# add backup_config
if [ -f "${BACKUP_CFG}" ]; then
  source ${BACKUP_CFG}
else
  log "BACKUP" "Config file ${BACKUP_CFG} not found. Exiting."
  exit 1
fi

# run pre scripts, if present and set as executable
for f in ${BACKUP_TOOLSDIR}/scripts.d/pre_*; do
  if [ -e $f ]; then
    source $f
  fi
done

# run backup
borg create ${BACKUP_OPTS} ${BACKUP_REPO}::${BACKUP_NAME} ${BACKUP_TARGETS}

# run post scripts, if present and set as executable
for f in ${BACKUP_TOOLSDIR}/scripts.d/post_*; do
  if [ -e $f ]; then
    source $f
  fi
done

log "BACKUP" "script completed"
