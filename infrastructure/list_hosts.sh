#! /bin/bash
# Use like:
# ./list_hosts rjones > hosts
# ./connect_cluster.sh

if [[ $# -eq 0 ]] ; then
    echo "Hey, you need to supply a user!" 
    exit 0
fi

/Users/rjones/Library/Python/2.7/bin/aws ec2 describe-instances --filters "Name=tag:User,Values=$1" | grep PublicDnsName | tr -d '"' | sed "s/PublicDnsName: //g" | tr -d "," | awk '{$1=$1};1' | uniq