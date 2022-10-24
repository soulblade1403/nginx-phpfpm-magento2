#!/bin/bash
set -aeuo pipefail

# Basic configuration: datestamp e.g. YYYYMMDD
DATE=$(date +"%Y%m%d")

# Location of your backups (create the directory first!)
BACKUP_DIR="./backup/mysql"

# MySQL login details
#MYSQL_USER=${MYSQL_USER}
#MYSQL_PASSWORD=${MYSQL_PASSWORD}

# MySQL executable locations (no need to change this)

MYSQL="docker exec ${PROJECT}-mysql /usr/bin/mysql"
MYSQLDUMP="docker exec ${PROJECT}-mysql /usr/bin/mysqldump"

# MySQL databases you wish to skip
SKIPDATABASES="Database|information_schema|sys|performance_schema|mysql"

# ---- DO NOT CHANGE BELOW THIS LINE ------------------------------------------
#
# Create a new directory into backup directory location for this date
mkdir -p $BACKUP_DIR

# Retrieve a list of all databases
databases=`$MYSQL -uroot -p${MYSQL_ROOT_PASSWORD} -e "SHOW DATABASES;" | grep -Ev "($SKIPDATABASES)"`

# Dumb the databases in seperate names and gzip the .sql file
for db in $databases; do
  echo $db
  if [ ! -d $BACKUP_DIR/$db ];then
    mkdir -p $BACKUP_DIR/$db
  fi
  $MYSQLDUMP -uroot -p${MYSQL_ROOT_PASSWORD} $db | gzip > "$BACKUP_DIR/$db/$DATE.sql.gz"
done

# Remove backup mysql files except the latest 7 files
for db in $databases; do
  find $BACKUP_DIR/$db -type f -mtime +7 -exec rm {} \;
done
