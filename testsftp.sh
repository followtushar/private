#!/bin/bash
#VARIABLES

files=("T-TXN-TRANFC-*-ITSCH.DAT" "AT-TXN-TRANFC-*-ITSCH.DAT" "R-SPAD-PASS-*-OPIEI.DAT" "R-RTUT-ITSIS-*-OPIEI.DAT" "R-SAPPR-ITSCH-*-OPIEI.DAT" "R-SBPC-ITSCH-$ITSCH-*-OPIEI.DAT" "R-SETL-ITSCH-*-OPIEI.DAT" "R-SNGD-ITSCH-*-OPIEI.DAT" "R-TREC-ITSCH-*-OPIEI.DAT")
user="SRCNTABI"
date=$(date '+%Y%m%d')
date="20211118"
sourcefolder="/usr/its/mms/outbox/ch/$date/*"
targetfolder="/nta-sftp-management/management-scripts/test/"
ipcopy= ("172.30.20.12" "172.30.20.18")
LOG="/NTABI/rsync.log"
i=0
#CODE


for i in "${ipcopy[@]}"; do
    if [[ ! -f $targetfolder/CONTROL-ITSCH-OPIEI-$date.success ]] ; then
        echo "Job has already run successfully today"
        exit 0
    fi
    success="true"
    echo "Initial: $success"
    for file in "${files[@]}"; do
        if [ "$file" == *"TXN"* ] ; then
            targetfolder= "/nta-sftp-management/management-scripts/test/TXN/"
        elif [ "$file" == *"SPAD"* ] ; then
            targetfolder= "/nta-sftp-management/management-scripts/test/Weekly/"
        fi
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
    fi
done 
if [ $success = "true" ] ; then echo "success" > $targetfolder/CONTROL-ITSCH-OPIEI-$date.success
#rm $targetfolder/CONTROL-ITSCH-OPIEI-$date.failed
echo "All jobs run successfully" else
#echo "failed" > $targetfolder/CONTROL-ITSCH-OPIEI-$date.failed
echo "Some jobs did not complete successfully"
fi


