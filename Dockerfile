FROM ibm-semeru-runtimes:open-17-jre-focal

# set timezone
ENV TZ Asia/Shanghai
ENV BASE_PATH=/home/mirai
ENV MCL_VERSION=2.1.2
WORKDIR $BASE_PATH
VOLUME $BASE_PATH

RUN cd $BASE_PATH && \
    apt update && \
    apt install unzip && \
    curl -OL https://github.com/iTXTech/mirai-console-loader/releases/download/v${MCL_VERSION}/mcl-${MCL_VERSION}.zip && \
    unzip mcl-${MCL_VERSION}.zip && \
    rm mcl-${MCL_VERSION}.zip && \
    chmod +x ./mcl && \
    # install chat-command
    ./mcl --update-package net.mamoe:chat-command --type plugin --channel stable
    
CMD ./mcl