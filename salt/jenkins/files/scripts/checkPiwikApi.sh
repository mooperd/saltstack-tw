#!/bin/bash

. ${dcmnJenkinsControl}/helper.sh

checkAllSitesViaApi() 
{
    piwikGetAllSites | awk -F',' '{ print "echo \"check website "$2"\"; statusCode=$(curl -s1 -u \"${jenkinsUser}:${jenkinsPassword}\" -o /dev/null -w \"%{http_code}\" \"http://control.dcmn.com:8080/job/Check-One-Site-Via-Api/buildWithParameters?token=beHappy&piwikSiteId="$1"\"); if [ $statusCode -eq 201 ]; then echo \"$statusCode\"; else echo \"$statusCode is not available\"; exit 1; fi; " }' | sh
}