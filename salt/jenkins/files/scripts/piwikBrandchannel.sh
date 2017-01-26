#!/bin/bash

. ${dcmnJenkinsControl}/helper.sh

echo "Start brandchannel analyse"
echo "http://report2.dcmn.com/index.php?module=API&method=Campaigns.doArchiving${enableDebug}&date=${piwikDate}&period=${piwikPeriod}&format=JSON&token_auth=${piwikToken}";
