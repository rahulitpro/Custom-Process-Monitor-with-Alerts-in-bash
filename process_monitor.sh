#!/bin/bash

############################################################################
#	Monitor CPU/memory usage of specific processes 
#	and trigger alerts (email, Telegram, desktop notification)
#	when thresholds are exceeded  
############################################################################

if [ "`uname`" != "Linux" -a ! -e "/usr/bin/pidstat1" ]
then
echo "This is not a Linux Server."
exit 1
elif [ ! -e "/usr/bin/pidstat" ]
then
echo "sysstat package is missing."
exit 1
fi


if [ $# -eq 0 ]
then
echo "Process ID not provided, using top load process for this"
PROSSID=`top -b -n 1 | head -n 8 | tail -1 | awk '{print $1}'`
else
PROSSID=${1}
echo "Checking process ID . . ."
if  [ $# -eq 1 -a "`ps -q ${PROSSID} | tail -1 | awk '{print $1}'`" == "${PROSSID}"  ]     ### Checking if we have only one argument and given process id is valid on server.
then
echo "Valid"
else 
echo "Please provide valid process id"
exit 1
fi
fi

echo "Following process will be monitor"
ps -p ${PROSSID} -o pid,cmd
echo "Collecting data . . . "

echo "# Time        UID       PID    %usr %system  %guest   %wait    %CPU   CPU  minflt/s  majflt/s     VSZ     RSS   %MEM   kB_rd/s   kB_wr/s kB_ccwr/s iodelay   cswch/s nvcswch/s threads   fd-nr prio policy  Command" > /tmp/process_${PROSSID}.txt
for i in {1..5}
do
sleep 5
pidstat -p ${PROSSID} -R -u -r -d -w -v -h | tail -1 | grep -v "# Time        UID       PID    %usr %system  %guest   %wait    %CPU   CPU  minflt/s  majflt/s     VSZ     RSS   %MEM   kB_rd/s   kB_wr/s kB_ccwr/s iodelay   cswch/s nvcswch/s threads   fd-nr prio policy  Command" | grep -v grep >> /tmp/process_${PROSSID}.txt
done
cat /tmp/process_${PROSSID}.txt

echo ""
echo "Uploading Files via API"

API_URL=http://192.168.122.211:5000/upload
FILE_TO_UPLOAD=/tmp/process_${PROSSID}.txt

curl -X POST -F "file=@${FILE_TO_UPLOAD}" ${API_URL} 

rm /tmp/process_${PROSSID}.txt

