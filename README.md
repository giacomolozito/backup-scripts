# borg-scripts

Set of bash scripts to simplify backups with [borg](https://www.borgbackup.org/).  
These are for my personal use, but shared with the open source community in case anyone finds them useful.

### Setup

Set up the following directory layout for backups:
```bash
# create backup directory
mkdir -p /backup
# initiate new repo, define encryption method
borg init -e ENCRYPTION /backup/repo
```

Then clone the repo under `/backup/borg-scripts` and rename `backup.sh.cfg.example` to `backup.sh.cfg`, configuring the values as desired (borg passphrase for the repo, directories of the machine to backup, etc.).

### Scheduled run

On distributions with systemd, the scheduled run can be configured used the timer and service files provided under utils/ . More generally, it's simply a case of putting `/backup/borg-scripts/backup.sh` to be executed in cron with the desired schedule.

### Pre/Post scripts

Before and after the backup is executed, scripts can be run by placing them in the scripts dir with a pre_ or post_ prefix and setting them as executable. These can be used to offload the backup somewhere, perform preparation and cleanup actions, etc.
