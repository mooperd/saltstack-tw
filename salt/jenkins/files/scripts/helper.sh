#!/bin/bash

# AWS Settings
export EC2_HOME=/opt/aws/apitools/ec2;
export JAVA_HOME=/usr/lib/jvm/jre;

checkUrl() 
{
    status=$(curl -s1 -o /dev/null -w "%{http_code}" $1);
    if [ $status -ne 200 ]; then echo $1" is not available"; exit 1; fi;
}

checkPiwikApi() 
{
    result=$(curl -s1 "$1" | jq '[.result,.message]' | jq -r '@csv' | tr -d '"');
   
    IFS=',' read -a status <<< "$result";

    if [ ${status[0]} == 'error' ]; then 
        echo $1" response following error: "${status[1]}; 
        exit 1;
    fi;
}

piwikGetAllSites()
{
    apiURL="http://report2.dcmn.com/index.php?module=API&method=SitesManager.getAllSites&format=JSON&token_auth=${piwikToken}";
    #apiURL="http://report2.dcmn.com/index.php?module=API&method=SitesManager.getAllSites&format=JSON&token_auth=b621c59ea7f70907b3da0d6afff890f8";

    checkUrl $apiURL;

    # are there websites to validate?
    numWebsites=$(curl -s1 $apiURL | jq 'keys' | jq -r '@csv' | grep -o -E ',' | wc -l);
    if [ $numWebsites -eq 0 ]; then echo "there are no piwik sites available!"; exit 1; fi;

    curl -s1 $apiURL | jq '.[]' | jq [.idsite,.name,.currency,.timezone,.ecommerce,.sitesearch,.ts_created,.main_url] | jq -r '@csv' | tr -d '"';
}

# true: if (($? == 0)); then
# false: if (($? == 1)); then
containsElement () 
{
    local e;
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done;
    return 1;
}
