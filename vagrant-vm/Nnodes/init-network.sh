#!/bin/bash

echo 'Init private PoA network'

echo 'Enter name of your private network'
read network_name

NETWORK_DIR=${network_name}_network
NETWORK_GENESIS_FILE=${network_name}_genesis.json

#Clean up previous network
#TODO instead of deleting move to back folder
rm -rf $NETWORK_DIR
mkdir $NETWORK_DIR
cd $NETWORK_DIR
mkdir logs

echo 'Enter number of nodes'
read num

echo "Creating ${num} nodes"

for ((i = 1; i <= $num; i++)) {
  geth --datadir nodes/node$i account new
  ACCOUNTS[$i]=`geth account list --keystore nodes/node$i/keystore | sed 's/^[^{]*{\([^{}]*\)}.*/\1/'`
  echo "New accouunt = ${ACCOUNTS[$i]}"
}

#Create PUPPETH_ARG
PUPPETH_ARG="$network_name\n2\n2\n10\n"

for _ in `seq 1 2`;
do
 for ((i = 1; i <= $num; i++)) {
    PUPPETH_ARG+="${ACCOUNTS[$i]}\n"
  }
  PUPPETH_ARG+="\n"
done

#GENERATE RANDOM ID for the network
PUPPETH_ARG+="\n"

#ADD SOMETHING FUN INTO A BLOCK
PUPPETH_ARG+="\n"

#GENERATE GENESIS FILE
PUPPETH_ARG+="2\n2\n$NETWORK_GENESIS_FILE\n"

echo "PUPPETH_ARG = $PUPPETH_ARG"

#CALL puppeth network manager and pass arguments
printf $PUPPETH_ARG | puppeth &> logs/puppeth_output.log

#GLOBAL_ARGS="--mine --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3"
GLOBAL_ARGS="--mine --rpc --rpcaddr 0.0.0.0"
RPC_START_PORT=42000
START_PORT=41000

#INIT and START network nodes
for ((i = 1; i <=$num; i++)) {
 echo "Init node $i" 
 geth --datadir nodes/node$i init $NETWORK_GENESIS_FILE &>> logs/node$i.log 
 echo "Start node $i" 
 echo "Type password for first node"
 read -s password
 echo $password > password$i.txt
 geth --datadir nodes/node$i $GLOBAL_ARGS  --unlock ${ACCOUNTS[$i]} --password password$i.txt \
                                      --rpcport $(($RPC_START_PORT + $i - 2)) --port $(($START_PORT + $i - 1)) &>> logs/node$i.log & 
 #rm -rf password$i.txt
}
echo "Setting up network ..."
sleep 10
#echo "[*] Sending first transaction"
#geth --exec 'loadScript("../script1.js")' attach nodes/node1/geth.ipc

#Create file of enodes
ENODES_FILE=enodes_list.txt
rm -rf $ENODES_FILE
for j in `seq 1 2`; do
  ind=1
  while [ $ind -le $num ]; do
  echo "Index i = $ind"
# Control will enter here if $DIRECTORY exists.
  if [ -e "nodes/node$ind/geth.ipc" ] 
  then
    echo "Directory found for node $ind"
    geth --exec 'admin.nodeInfo.enode' attach nodes/node$ind/geth.ipc >> $ENODES_FILE 
    ((ind++))
  else 
   echo "Network $ind is not started"
   if [ $j -eq 1 ]; then
      echo "Sleep for 2 seconds to wait for network $ind"
      sleep 2
   fi
  ((ind++))
fi
done
done

echo 'To stop network, type exit'
read val
COMMAND=`echo $val | tr '[:upper:]' '[:lower:]'`
if [ $COMMAND = 'exit' ]
then
  killall -HUP geth &>/dev/null
  for ((i = 1; i <=$num; i++)) {
    rm -rf password$i.txt
  }
fi

