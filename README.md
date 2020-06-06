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
