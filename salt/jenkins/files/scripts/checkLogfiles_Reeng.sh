#!/bin/bash

echo "check current log files"
ssh -t -t -o StrictHostKeyChecking=no -i ${pemFile2} ${sshUserCentos}@${dataHostname} "python /home/centos/loganalytics/logrotate/check_logfiles.py"