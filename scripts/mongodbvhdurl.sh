#!/bin/sh
#srcdir="/usr/share/jenkins"
#cat $srcdir/mongodbvhdurl.secrets
appid=`awk -F, '{print $1}'`
clientsecret=`awk -F, '{print $2}'`
tentantid=`awk -F, '{print $3}'`
storageAcc=`awk -F, '{print $4}'`
az login --service-principal -u $appid --password $clientsecret --tenant $tentantid > /dev/null
az storage blob list -c system --account-name $storageAcc > vhd
vhdurl=`cat vhd | jq '.[] | .name' | sed 's/"//' | sed 's/"//' | grep *.vhd`
echo "This $vhdurl"
newvhdurl="https://$4.blob.core.windows.net/system/$vhdurl"
echo $newvhdurl
