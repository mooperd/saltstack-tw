#!/bin/bash

. ${dcmnJenkinsControl}/helper.sh

trackingJsTargetDir=${trackingJsTargetDir="/var/www/users/data/html/v2/"}

siteIds=`piwikGetAllSites | awk -F',' '{ print $1; }'`;

for siteId in $siteIds
do
    echo $siteId;

    wget "${piwikApiUrl}/plugins/ContainerTag/js/$siteId.js" -O "${WORKSPACE}/"tracking$siteId.js || rm -f "${WORKSPACE}/"tracking$siteId.js
    wget "${piwikApiUrl}/plugins/ContainerTag/js/v2/$siteId.js" -O "${WORKSPACE}/"t$siteId.js || rm -f "${WORKSPACE}/"t$siteId.js
done


# write local js files (piwik api)
#siteIds=`wget -q -O - "$@" "${piwikApiUrl}/index.php?module=API&method=SitesManager.getAllSitesId&format=Csv&token_auth=b621c59ea7f70907b3da0d6afff890f8&translateColumnNames=1"`
