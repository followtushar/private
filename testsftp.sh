#!/bin/bash
#VARIABLES

files=("T-TXN-TRANFC-*-ITSCH.DAT" "AT-TXN-TRANFC-*-ITSCH.DAT" "R-SPAD-PASS-*-OPIEI.DAT" "R-RTUT-ITSIS-*-OPIEI.DAT" "R-SAPPR-ITSCH-*-OPIEI.DAT" "R-SBPC-ITSCH-$ITSCH-*-OPIEI.DAT" "R-SETL-ITSCH-*-OPIEI.DAT" "R-SNGD-ITSCH-*-OPIEI.DAT" "R-TREC-ITSCH-*-OPIEI.DAT")
user="SRCNTABI"
date=$(date '+%Y%m%d')
#date="20210531"
sourcefolder="/usr/its/mms/outbox/ch/$date/*"
targetfolder="/nta-sftp-management/management-scripts/test/"
ipcopy=( "172.30.20.12" "172.30.20.18" )
LOG="/NTABI/rsync.log"
i=0
#CODE


if [[ -f $targetfolder/CONTROL-ITSCH-OPIEI-$date.success ]] ; then
    echo "Job has already run successfully today"
exit 0
fi

for i in "${ipcopy[@]}"; do
    success="true"
    echo "Initial: $success"
    for file in "${files[@]}"; do
        echo $success
        echo "Checking files for file: $file"
        scp -rp $user@$i:$sourcefolder/$file $targetfolder
        error=$?
    done
        if [ "$error" = "0" ] ; then
        echo "$file is copied with success" 
        elif [ "$error" = "1" ] ; then
            success="false"
        echo "$file does not exist"
        else
            success="false"
done    
