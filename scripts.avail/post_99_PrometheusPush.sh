#!/bin/bash
#
# this is meant to be sourced by backup.sh and will use variables defined there
#
# send information to a Prometheus Push Gateway about the backup outcome

HOSTNAME=$(hostname)
log "PROMETHEUS" "Sending backup results to Prometheus"
cat <<EOF | curl -s --data-binary @- http://${BACKUP_PROMPG_HOST}/metrics/job/borg_backup_sched/instance/${HOSTNAME}
# TYPE borg_backup_sched_result gauge
# HELP borg_backup_sched_result A metric representing backup outcome (0 = success, 1 = warnings, 2 = failure)
borg_backup_sched_result{host="${HOSTNAME}"} ${BACKUP_RESULT}
EOF
if [ $? != 0 ]; then
  set_backup_result 1
fi
