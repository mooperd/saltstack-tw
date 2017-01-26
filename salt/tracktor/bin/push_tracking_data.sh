#!/bin/bash

TRACKING_LOG_PATH="/var/log/nginx/tracking"
TMP_LOG_PATH="${TRACKING_LOG_PATH}/tmp_`date +'%Y-%m-%d_%H%M%S'`_${RANDOM}"
S3_CFG_PATH="${HOME}/.aws/s3-config"
S3_LOG_PATH="s3://piwik-tracking-logs"
DATE_MAX=`date +'%Y-%m-%d' -d '1 day ago'`
DATE_START=$1
DATE_END=$2

error() {
    awk " BEGIN { print \"$@\" > \"/dev/fd/2\" }"
    exit 1
}

# Check S3 access
if [ -f $S3_CFG_PATH ]; then
   export AWS_CONFIG_FILE=$S3_CFG_PATH
else
   error "S3 credentials do not exist"
fi

aws s3 ls "${S3_LOG_PATH}" > /dev/null
if [ $? != 0 ]; then
    error "S3 credentials are invalid"
fi

# Check arguments
if [ "$DATE_START" == "" ]; then
    DATE_START="${DATE_MAX}"
fi

if [ "$DATE_END" == "" ]; then
    DATE_END="${DATE_START}"
fi

if [[ ! "$DATE_START" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || [[ ! "$DATE_END" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] ; then
    error "Invalid date format given, please use '%Y-%m-%d'"
fi

DATE_MAX_INT=`echo $DATE_MAX | sed 's/[^0-9]//g'`
DATE_START_INT=`echo $DATE_START | sed 's/[^0-9]//g'`
DATE_END_INT=`echo $DATE_END | sed 's/[^0-9]//g'`

if [ $DATE_END_INT \> $DATE_MAX_INT ]; then
    error "End date '${DATE_END}' is greater than max date '${DATE_MAX}'"
fi

mkdir "${TMP_LOG_PATH}"
if [ $? != 0 ]; then
    error "Failed to create temporary directory '${TMP_LOG_PATH}'"
fi

FILES=`find "${TRACKING_LOG_PATH}/" -type f -name "*_*_*.log"`
for FILE in $FILES; do
    BASENAME=`basename $FILE`

    DATE_FILE=`echo ${BASENAME} | sed 's/^\([0-9]*-[0-9]*-[0-9]*\).*$/\1/'`
    DATE_FILE_INT=`echo $DATE_FILE | sed 's/[^0-9]//g'`

    if [ $DATE_FILE_INT \< $DATE_START_INT ] || [ $DATE_FILE_INT \> $DATE_END_INT ]; then
        echo "skipping ${BASENAME}"
        continue
    fi

    mkdir -p "${TMP_LOG_PATH}/${DATE_FILE}"
    if [ $? != 0 ]; then
        error "Failed to create directory '${TMP_LOG_PATH}/${DATE_FILE}'"
    fi

    BASENAME_NEW=$(echo ${BASENAME} | sed 's/[^_]*_\(.*\)$/\1/')
    BASENAME_NEW="$(hostname)_${BASENAME_NEW}"
    mv "${FILE}" "${TMP_LOG_PATH}/${DATE_FILE}/${BASENAME_NEW}"
    if [ $? != 0 ]; then
        error "Failed to move file '${FILE}' to '${TMP_LOG_PATH}/${DATE_FILE}/${BASENAME_NEW}'"
    fi
done

gzip -9 -r "${TMP_LOG_PATH}/"
if [ $? != 0 ]; then
    error "Failed to compress all files in '${TMP_LOG_PATH}/'"
fi

aws s3 mv "${TMP_LOG_PATH}/" "${S3_LOG_PATH}/" --recursive
if [ $? != 0 ]; then
    error "Failed to move all files of '${TMP_LOG_PATH}/' to '${S3_LOG_PATH}/'"
fi

rm -Rf "${TMP_LOG_PATH}"
if [ $? != 0 ]; then
    error "Failed to remove temporary directory '${TMP_LOG_PATH}'"
fi
