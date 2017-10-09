#!/bin/sh
srcdir="/usr/share/jenkins"
#cat $srcdir/mongodbvhdurl.secrets
appid=`awk -F, '{print $1}' $srcdir/mongodbvhdurl.secrets`
clientsecret=`awk -F, '{print $2}' $srcdir/mongodbvhdurl.secrets`
tentantid=`awk -F, '{print $3}' $srcdir/mongodbvhdurl.secrets`
storageAcc=`awk -F, '{print $4}' $srcdir/mongodbvhdurl.secrets`
az login --service-principal -u $appid --password $clientsecret --tenant $tentantid > /dev/null
az storage blob list -c system --account-name $storageAcc > vhd
vhdurl=`cat vhd | jq '.[] | .name' | sed 's/"//' | sed 's/"//' | grep vhd | head -n 1`
newvhdurl="https://$storageAcc.blob.core.windows.net/system/$vhdurl"
echo $newvhdurl
cp /var/lib/jenkins/jobs/MongoDBTerraformjob/config.xml /tmp/updateurlconfig.xml
sed "s,UpdateUrl,$newvhdurl,g" /tmp/updateurlconfig.xml > /var/lib/jenkins/jobs/MongoDBTerraformjob/config.xml
