#!/bin/bash

# Check to make sure the user has entered exactly two arguments.
if [ $# -ne 2 ]
then
	$(which echo) "Usage: Backup.sh <source_directory> <target_directory>"
	$(which echo) "Please try again."
	exit 1
fi

# Check to see if 'rsync' is installed.
if ! command -v $(which rsync) > /dev/null 2>&1
then
	$(which echo) "This script requires rsync to be installed."
	$(which echo) "Please use your distribution's package manager to install it and try again."
	exit 2
fi

# Capture the current date, and store it in the format YYYY-MM-DD_HH-MM-SS
current_date_and_time=$($(which date) +%Y-%m-%d_%H-%M-%S)

rsync_options="-avb --backup-dir $2/$current_date_and_time --delete --dry-run"

$(which rsync) $rsync_options $1 $2/current_backup >> backup_$current_date_and_time.log
