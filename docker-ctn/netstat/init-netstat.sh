#!/bin/bash

echo "[*] Enter number of nodes in the network"
read num

NET_SECRET="random_secret"

#INIT NETSTAT
cd /home/netstat
cd eth-netstats
(WS_SECRET=$NET_SECRET npm start &)
cd ../


cd eth-net-intelligence-api
bash ../netstatconf.sh $num node  http://localhost:3000 $NET_SECRET > app.json
(pm2 start app.json &)
open http://localhost:3000
cd ../../

