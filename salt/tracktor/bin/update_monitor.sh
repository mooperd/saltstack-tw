#!/bin/bash

MAIN_HOST="t.dcmn.com"
AWS_HOST="aws.dcmn.com"
TRACKING_LOG_PATH="/var/log/nginx/tracking"
HEALTHCHECK_PATH="/usr/share/nginx/html/healthcheck.txt"
MONITOR_STATUS_PATH="/usr/share/nginx/html/monitor/status.txt"
CHECK_MINUTES_COUNT=10

err=0

last_update=`date --rfc-3339=n`

# The ls command fails if it doesn't find any files
# so we count the number of files before ls them
count_ls=$(find "${TRACKING_LOG_PATH}" -type f -name "*_*_*.log" | wc -l)
if [ $count_ls != 0 ]; then
    newest_ls=$(ls -tlGh --full-time ${TRACKING_LOG_PATH}/*_*_*.log)
    newest="$(echo "$newest_ls" | head -1)"
    newest_date="$(echo $newest | awk '{print $5, $6}')"
    newest_file="$(echo $newest | awk '{print $8}')"
    newest_file="${newest_file##*/}"

    oldest=$(ls -tlG --full-time --reverse ${TRACKING_LOG_PATH}/*_*_*.log | head -1)
    oldest_date="$(echo $oldest | awk '{print $5, $6}')"
    oldest_file="$(echo $oldest | awk '{print $8}')"
    oldest_file="${oldest_file##*/}"
fi

host_current_short=$(hostname -s)
host_current="$host_current_short.$AWS_HOST"
host_active=$(dig CNAME $MAIN_HOST +short)
if [ $? != 0 ]; then
    err=1
    host_active_short="ERROR: Failed to resolve active host: ${host_active}"
    host_active="????"
else
    host_active="${host_active%?}"
    host_active_short="${host_active%%.*}"
    if [ "$host_active_short" == "" ]; then
        err=1
    fi
fi

last_minutes_count=$(find "${TRACKING_LOG_PATH}" -type f -name "*_*_*.log" -mmin -$CHECK_MINUTES_COUNT | wc -l)
if [ $last_minutes_count -eq 0 ] && [ "${host_active_short}" == "${host_current_short}" ]; then
    err=1
fi

healthcheck="OK"
if [ $err != 0 ]; then
    healthcheck="FAIL"
fi

out="HEALTHCHECK: $healthcheck
Last updated: $last_update
Newest date:  $newest_date
Newest file:  $newest_file
Oldest date:  $oldest_date
Oldest file:  $oldest_file
Current host: $host_current_short (http://$host_current/monitor/status.txt)
Active host:  $host_active_short (http://$host_active/monitor/status.txt)

Number of customers received data in the last $CHECK_MINUTES_COUNT minutes: $last_minutes_count"

echo "$out" | head -1 > $HEALTHCHECK_PATH
echo -e "$out\n\nALL:\n$(echo "$newest_ls" | awk '{print $4, $5, $6, $8}' | tr ' ' \\t)" > $MONITOR_STATUS_PATH
echo "$out"
exit $err
