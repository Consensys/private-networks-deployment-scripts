#!/bin/bash
set -eu -o pipefail

# install build deps
add-apt-repository ppa:ethereum/ethereum
apt-get update
apt-get install -y build-essential unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk \
                   git python dstat ntp nodejs solc ethereum npm


# For custom build config
#sudo npm install -g node-gyp truffle@3.4.11 \
#        truffle-default-builder ether-pudding rimraf web3@0.20.2 \
#        ethereumjs-testrpc@6.0.3 q


# install golang
GOREL=go1.7.3.linux-amd64.tar.gz
wget -q https://storage.googleapis.com/golang/$GOREL
tar xfz $GOREL
mv go /usr/local/go
rm -f $GOREL
PATH=$PATH:/usr/local/go/bin
echo 'PATH=$PATH:/usr/local/go/bin' >> /home/ubuntu/.bashrc

# install Porosity
wget -q https://github.com/jpmorganchase/quorum/releases/download/v1.2.0/porosity
mv porosity /usr/local/bin && chmod 0755 /usr/local/bin/porosity

# copy examples
cp -r /vagrant/Nnodes /home/ubuntu/Nnodes
#chown -R ubuntu:ubuntu /home/ubuntu/7nodes

# done!
banner "Consensys"
echo
echo 'The Consensys vagrant instance has been provisioned'
echo "Use 'vagrant ssh' to open a terminal, 'vagrant suspend' to stop the instance, and 'vagrant destroy' to remove it."
