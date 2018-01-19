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

#GENERATE GENESIS FILE
PUPPETH_ARG+="2\n2\n$NETWORK_GENESIS_FILE\n"

echo "PUPPETH_ARG = $PUPPETH_ARG"


#CALL puppeth network manager and pass arguments
printf $PUPPETH_ARG | puppeth &> logs/puppeth_output.log

#INIT network nodes
for ((i = 1; i <=$num; i++)) {
 echo "Init node $i" 
 geth --datadir nodes/node$i init $NETWORK_GENESIS_FILE
}

cd ../


