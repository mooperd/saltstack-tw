#!/bin/bash

echo "check current log files"
ssh -t -t -o StrictHostKeyChecking=no -i ${pemFile} ${sshUser}@${dataHostname} "python /home/ec2-user/loganalytics/check_logfiles.py"