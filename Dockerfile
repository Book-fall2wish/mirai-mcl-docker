FROM ibm-semeru-runtimes:open-17-jre-focal

ENV TZ Asia/Shanghai
ENV BASE_PATH=/home/mirai
#ENV MCL_VERSION=2.1.2
WORKDIR $BASE_PATH

# 设置JVM参数
ENV JAVA_TOOL_OPTIONS="-Dmirai.console.skip-end-user-readme"

# 添加字体文件
COPY HarmonyOS_Sans_Regular.ttf /usr/share/fonts/

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
    ./mcl -u --dry-run && \
    
    # Clean up
    fc-cache -f && \
    apt-get purge -y unzip && \
    apt-get autoremove -y && \
    apt-get install -y iputils-ping && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

    # start to update
    ./mcl -u

CMD ["./mcl", "-u"]
