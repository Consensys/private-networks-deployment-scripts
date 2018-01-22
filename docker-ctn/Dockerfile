FROM ubuntu:latest


RUN apt-get update && \
    apt-get install -y \
            build-essential \
            git \
            libdb-dev \
            libsodium-dev \
            libtinfo-dev \
            sysvbanner \
            unzip \
            wget \
            wrk \
            zlib1g-dev 


ENV GOREL go1.7.3.linux-amd64.tar.gz
ENV PATH $PATH:/usr/local/go/bin

RUN wget -q https://storage.googleapis.com/golang/$GOREL && \
    tar xfz $GOREL && \
    mv go /usr/local/go && \
    rm -f $GOREL

RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:ethereum/ethereum && \
    apt-get update 

# Install add-apt-repository
RUN apt-get install -y build-essential unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk \
                   git python dstat ntp nodejs solc ethereum npm software-properties-common vim

RUN mkdir -p /home/Nnodes
ADD Nnodes /home/Nnodes
#RUN cd /home/Nnodes

# Temporary useful tools
#RUN apt-get update && \
#        apt-get install -y iputils-ping net-tools vim

