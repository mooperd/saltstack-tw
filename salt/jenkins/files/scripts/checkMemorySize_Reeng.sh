#!/bin/bash

user=$1;
host=$2;
maxValue=$3;

echo "get current log files"
ssh -t -t -o StrictHostKeyChecking=no -i ${pemFile2} $user@$host <<ENDSSH
#!/bin/bash

value=\$(df -h | grep "xvda1" | awk '{ print \$5+0 }');

if [ \$value -gt $maxValue ]; then
    echo "ATTENTION!!! There is not enough memory at "$host" anymore!!";
    exit 1;
fi;

exit 0;
ENDSSH
