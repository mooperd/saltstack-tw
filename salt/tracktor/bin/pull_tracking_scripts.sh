#!/bin/bash

DOCUMENT_ROOT="/usr/share/nginx/html"
S3_CFG_PATH="${HOME}/.aws/s3-config"
S3_LOG_PATH="s3://js-objects"

error() {
    awk " BEGIN { print \"$@\" > \"/dev/fd/2\" }"
    exit 1
}

export AWS_CONFIG_FILE="${S3_CFG_PATH}"
aws s3 cp "${S3_LOG_PATH}/" "${DOCUMENT_ROOT}/" --recursive
if [ $? != 0 ]; then
    error "Failed to copy files from '${S3_LOG_PATH}/' to '${DOCUMENT_ROOT}/'"
fi
