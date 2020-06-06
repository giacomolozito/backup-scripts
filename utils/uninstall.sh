#!/bin/bash
#
# Uninstall script for systemd service and timer files

systemctl stop borg-backup-sched.timer
systemctl disable borg-backup-sched.timer
rm -f /etc/systemd/system/borg-backup-sched.*
systemctl daemon-reload
