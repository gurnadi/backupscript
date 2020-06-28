#!/bin/bash
MAILTO='';
SCRIPTDIR="/root/script";
BACKUPNFS="192.168.200.18:/home/BACKUP/namaclient/html/";
BACKUPDIR="/backup_website";
WEBDIR="/usr/share/nginx/html";

#Tentukan jumlah backup yang akan disimpan pada folder weekly dan daily
JUMLAHBACKUPMINGGUAN=3;
JUMHLAHBACKUPHARIAN=12;

WEEKLY=`date +%A`
MONTHLY=`date +%d`
TANGGAL=`date +%Y%m%d`

mount -o rw,udp,async,rsize=65536,wsize=65536 $BACKUPNFS $BACKUPDIR

#if [ "$WEEKLY" != "Saturday" ] && [ "$MONTHLY" != "01" ]; then
        tar czpvf $BACKUPDIR/daily/namaclient-`date +%Y%m%d`-`date +%H:%M`.tar.gz $WEBDIR;
#fi

if [ "$MONTHLY" == "01" ]; then
        CHECKINGMONTHLY=`ls  $BACKUPDIR/monthly/ | grep $TANGGAL`
        if [ "$CHECKINGMONTHLY" == "" ]; then
                tar czpvf $BACKUPDIR/monthly/namaclient-`date +%Y%m%d`-`date +%H:%M`.tar.gz $WEBDIR;
        fi
fi

if [ "$WEEKLY" == "Saturday" ]; then
        CHECKINGWEEKLY=`ls  $BACKUPDIR/weekly/ | grep $TANGGAL`
        if [ "$CHECKINGWEEKLY" == "" ]; then
                tar czpvf $BACKUPDIR/weekly/namaclient-`date +%Y%m%d`-`date +%H:%M`.tar.gz $WEBDIR;
        fi
fi

#TOTALDAILYBACKUP=`ls $BACKUPDIR/daily/ | wc -l`
#TOTALWEEKLYBACKUP=`ls $BACKUPDIR/weekly/ | wc -l`

# akan dibuka saat nanti jumlah backup sudah lebih dari 12
#if [ "$TOTALDAILYBACKUP" -gt "$JUMLAHBACKUPHARIAN" ]; then
#       SIAPKANHAPUS1=`expr $TOTALDAILYBACKUP - $JUMLAHBACKUPHARIAN`
#       NAMA2FILE1=`ls $BACKUPDIR/daily/ | sort -r | tail -n $SIAPKANHAPUS1`
#       for i in $NAMA2FILE1; do rm -f $i; done
#fi

# akan dibuka saat nanti jumlah backup sudah lebih dari 3
#if [ "$TOTALWEEKLYBACKUP" -gt "$JUMLAHBACKUPMINGGUAN" ]; then
#        SIAPKANHAPUS2=`expr $TOTALWEEKLYBACKUP - $JUMLAHBACKUPMINGGUAN`
#        NAMA2FILE2=`ls $BACKUPDIR/weekly/ | sort -r | tail -n $SIAPKANHAPUS2`
#       for i in $NAMA2FILE2; do rm -f $i; done
#fi

umount $BACKUPDIR
