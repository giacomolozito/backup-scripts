#!/bin/bash
#
# Install script for systemd service and timer files

cp systemd/borg-backup-sched.* /etc/systemd/system/
chown root.root /etc/systemd/system/borg-backup-sched.*

systemctl enable borg-backup-sched.timer
systemctl start borg-backup-sched.timer
systemctl daemon-reload
