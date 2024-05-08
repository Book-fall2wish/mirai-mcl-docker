FROM ibm-semeru-runtimes:open-17-jre-focal

ENV TZ Asia/Shanghai
ENV BASE_PATH=/home/mirai
ENV MCL_VERSION=2.1.2
WORKDIR $BASE_PATH
RUN cd $BASE_PATH && \
    apt update && \
    apt install -y unzip wget primus-libs && \
    wget https://github.com/MrXiaoM/mirai-console-loader/releases/download/v2.1.2-patch1/with-overflow.zip && \
    unzip with-overflow.zip && \
    rm with-overflow.zip && \
    chmod +x ./mcl && \
    
    # install plugins
    ./mcl --update-package net.mamoe:chat-command --channel maven-stable --type plugin && \
    ./mcl --update-package xyz.cssxsh.mirai:mirai-skia-plugin --channel maven-stable --type plugins && \
    ./mcl --update-package top.colter:bilibili-dynamic-mirai-plugin --channel maven --type plugin && \
    
    # initial start
    echo "/mclx update" | ./mcl -u --dry-run && \
    ./mcl -u && \
    
    # Clean up
    apt-get purge -y unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["./mcl"]
