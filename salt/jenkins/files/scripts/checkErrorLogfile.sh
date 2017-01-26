#!/bin/bash

homePath="/home/ec2-user/";

s3LogFilesBucketRoot="s3://logrotation/";
s3LogFilesDirectory=$s3LogFilesBucketRoot$1'/';

echo "checking "$s3LogFilesDirectory" for error.log";
export AWS_CONFIG_FILE=$homePath'.aws/config';
value=$(aws s3 ls $s3LogFilesDirectory | grep -ic 'error.log');

if [ $value -gt 0 ]; then
    echo "ATTENTION!!! There were logging errors yesterday!!";
    exit 1;
fi;
