
#! /bin/bash
# Dijeesh Padinhaethil

# Script to take MySQL backups to remote server using Percona Xtrabackup



# Confirm log directory exist, create on if doesn't.

  if [[ ! -e /var/log/xtrabackup ]]; then
          mkdir /var/log/xtrabackup
  fi


# Define ENV Variables
readonly JOB_ID=$(/bin/date +%Y%m%d%H)

LOG_DIR="/var/log/xtrabackup"
LOG="$LOG_DIR/${JOB_ID}_$(hostname)_backup.log"
XBLOG="$LOG_DIR/${JOB_ID}_$(hostname)_xb.log"

BACKUP_HOST="BACKUP_VAULT_IPADDR"
BACKUP_USER="SSHUSER"
MYSQL_USER="MYSQLUSER"
MYSQL_PASS="MYSQLPASSWORD"
BACKUP_FILE="$(hostname)_$(date +%Y%m%d%H)".tar




## Initiate Log file
echo "$(date +%F-%H:%M:%S) $JOB_ID SSH  Starting full backup process, job id $JOB_ID" >> "$LOG"

## Verify SSH access to the MySQL server and exit if no connections can be made.

status=$(ssh -o BatchMode=yes -o ConnectTimeout=5 "$BACKUP_USER"@$BACKUP_HOST echo ok 2>&1)
echo "$status"
        if [[ $status == ok ]]
                then   # Proceed with backup process
                echo "$(date +%F-%H:%M:%S) $JOB_ID SSH Connection success, proceeding with backup process" >> "$LOG"
                innobackupex  --user="$MYSQL_USER" --password="$MYSQL_PASS"  --stream=tar ./ 2>> "$XBLOG" | ssh "$BACKUP_USER"@"$BACKUP_HOST" \ "cat - > $BACKUP_FILE "

                # Verify xtrabackup logs and notify if MySQL backup has failed
                if [ -z $(tail -1 "$XBLOG"| grep 'completed OK!') ]
                      then
                        echo "$(date +%F-%H:%M:%S) $JOB_ID Xtrabackup failed, check backups xtrabackup logs for more information" >> "$LOG"
                      else
                        echo "$(date +%F-%H:%M:%S) $JOB_ID backup completes successfully" >> "$LOG"
                fi
        else
            echo "Xtrabackup failed, unable to connect remote server" >> "$LOG"
            fi
exit
