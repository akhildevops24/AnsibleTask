#!/bin/bash

USER="admin"
PASSWORD="s3cr3t"
TIMESTAMP=$(date +%Y%m%d%H%M)
BACKUP_DIR="/mysql/xtrabackup"
ARCHIVE_SERVER="backup1.local"
REMOTE_ARCHIVE_DIR="/mysql/xtrabackup-${TIMESTAMP}"
rm -rf ${BACKUP_DIR}/*
innobackupex --user ${USER} --password ${PASSWORD} --no-timestamp ${BACKUP_DIR} && echo -e "\nCreated backup..." || (echo -e "\nBackup failed!"; exit 1)
innobackupex --apply-log $BACKUP_DIR && echo -e "\nPrepared backup..." || (echo -e "\nPreparation of backup failed!" ; exit 1)
echo -n "Preparing transport ..."
/usr/bin/rsync -aqze "ssh -o StriyctHostKeyCheckingctHostKeyChecking=no -o UserKnownHostsFile=/dev/null" ${BACKUP_DIR}/ backup.local:${REMOTE_ARCHIVE_DIR}/ && echo -e "\nBackup successfully copied to ${ARCHIVE_SERVER}:${REMOTE_ARCHIVE_DIR}" || echo -e "/nTransport failed!"


