#!/bin/bash
#
# this is meant to be sourced by backup.sh and will use variables defined there
#
# send backup result and statistics to a Prometheus Push Gateway
# (also see utils/grafana for a dashboard reporting on these metrics)

HOSTNAME=$(hostname)
BACKUP_SIZE=$(du -d 0 -B K ${BACKUP_REPO} | cut -d 'K' -f 1)
log "PROMETHEUS" "Sending backup results to Prometheus"
cat <<EOF | curl -s --data-binary @- http://${BACKUP_PROMPG_HOST}/metrics/job/borg_backup_sched/instance/${HOSTNAME}
# TYPE borg_backup_sched_result gauge
# HELP borg_backup_sched_result A metric representing backup outcome (0 = success, 1 = warnings, 2 = failure)
borg_backup_sched_result{host="${HOSTNAME}"} ${BACKUP_RESULT}
# TYPE borg_backup_sched_size gauge
# HELP borg_backup_sched_size A metric showing backup size, in KiB
borg_backup_sched_size{host="${HOSTNAME}"} ${BACKUP_SIZE}
# TYPE borg_backup_sched_duration gauge
# HELP borg_backup_sched_duration A metric showing the time required to take backup, in seconds
borg_backup_sched_duration{host="${HOSTNAME}"} ${BACKUP_TIME_DURATION}
EOF
if [ $? != 0 ]; then
  set_backup_result 1
fi
