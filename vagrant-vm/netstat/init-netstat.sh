#!/bin/bash

echo "[*] Enter number of nodes in the network"
read num

echo "[*] Creating ${num} nodes"
NET_SECRET="random_secret"
#INIT NETSTAT
git clone https://github.com/cubedro/eth-netstats
cd eth-netstats
WS_SECRET=$NET_SECRET npm start &
cd ../

git clone https://github.com/cubedro/eth-net-intelligence-api
cd eth-net-intelligence-api
npm install
sudo npm install -g pm2
bash netstatconf.sh $num node  http://localhost:3000 $NET_SECRET > app.json
pm2 start app.json &
open http://localhost:3000
cd ../




