#!/bin/sh
#srcdir="/usr/share/jenkins"
#cat $srcdir/mongodbvhdurl.secrets
appid=$1
clientsecret=$2
tentantid=$3
storageAcc=$4
az login --service-principal -u $appid --password $clientsecret --tenant $tentantid > /dev/null
az storage blob list -c system --account-name $storageAcc > vhd
vhdurl=`cat vhd | jq '.[] | .name' | sed 's/"//' | sed 's/"//' | grep *.vhd`
echo "This $vhdurl"
newvhdurl="https://$4.blob.core.windows.net/system/$vhdurl"
echo $newvhdurl
