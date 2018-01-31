# private-networks-deployment-scripts
This repository contains out-of-the-box deployment scripts for ethereum private PoA networks. 
There are 2 sandboxes - vagrant virtual machine and docker container setups, both can be used to create dev environment, initiate and run a private network.
Puppeth network manager is used to create new network and generate genesis file.

**The goal** is to create 'out-of-box', 'one-click' solution for setting up new private ethereum network.


In progress:

  * Test, test, test ...
  * Find out why docker is so slow
  * Add netstat
  * Use only 1 folder with init-network.sh, try to avoid duplication.
  

## Running vagrant VM

In the top level directory:

    $ cd vagrant-vm
    $ vagrant up
    $ vagrant ssh
    $ sudo -i
    $ cd /home/ubuntu/Nnodes/
    $ ./init-network.sh
    
Script will ask you to define a name of future network, amount of nodes, password for each node...    
 

## Running docker container

In the top level directory:

    $ cd docker-ctn
    $ docker build -t $CONTAINER_NAME .
    $ docker run -p 3000:3000 --name $CONTAINER_INSTANCE_NAME -i -t $CONTAINER_NAME
    $ cd /home/Nnodes
    $ ./init-network.sh
    
To connect to node console via IPC, please type
    
    $ geth attach ipc:nodes/NODE_NUM/geth.ipc

    
    
