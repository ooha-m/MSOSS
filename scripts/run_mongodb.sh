#!/bin/bash
exec 2>&1

if pgrep -x "mongod" > /dev/null
then
        echo "mongod process is Running"
        processid=`ps -eaf | grep hab-sup | awk '{print $2,$3}' | head -n 1`
        kill -9 $processid
        echo "mongod process killed"
else
        echo "mongod process is not running"
fi

if pgrep -x "hab-sup" > /dev/null
then
        echo "hab-sup process is Running"
        processid=`ps -eaf | grep hab-sup | awk '{print $2,$3}' | head -n 1`
        kill -9 $processid
        echo "hab-sup process killed"
else
        echo "hab-sup process is not running"
        echo "Downloding the MongoDB HART File..."
        mkdir /scripts/HART
        wget -P https://github.com/sysgain/MSOSS/raw/habcode/Mongodb.tar.gz /hab/
        nohup hab sup start core/mongodb >> /scripts/sup-mongodb.log 2>1 &
fi
