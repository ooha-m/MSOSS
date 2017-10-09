#!/bin/sh
#srcdir="/usr/share/jenkins"
#cat $srcdir/mongodbvhdurl.secrets
appid=$1
clientsecret=$2
tentantid=$3
storageAcc=$4
az login --service-principal -u $appid --password $clientsecret --tenant $tentantid
az storage blob list -c system --account-name $storageAcc > vhd
vhdurl=`cat vhd | jq '.[] | .name' | head -n 1 | sed 's/"//' | sed 's/"//'`
echo $vhdurl
