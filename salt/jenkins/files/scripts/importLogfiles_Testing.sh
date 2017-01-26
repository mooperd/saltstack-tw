#!/bin/bash

logFileDateTime=$(date +'%Y%m%d-%H%M%S');

echo "starting logrotate";
ssh -t -t -o StrictHostKeyChecking=no -i ${pemFile2} ${sshUserCentos}@${dataHostname_testing} "sudo sh /home/${sshUserCentos}/loganalytics/logrotate/logrotate.sh '"$logFileDateTime"'";

if [ $? == 0 ]; then
    echo "start importing logs at report2.9";
    curl -u 'dcmn:Login;123' 'http://control.dcmn.com:8080/job/Import-LogFiles-To-Piwik2.9-Manually/buildWithParameters?token=beHappy&s3DirectoryName='$logFileDateTime;

    echo "check is error logfile exisiting";
    curl -u 'dcmn:Login;123' 'http://control.dcmn.com:8080/job/Check-Is-Error-Logfile-Exisiting/buildWithParameters?token=beHappy&s3DirectoryName='$logFileDateTime;
fi;
