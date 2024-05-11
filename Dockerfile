FROM ibm-semeru-runtimes:open-17-jre-focal

ENV TZ Asia/Shanghai
ENV BASE_PATH=/home/mirai
#ENV MCL_VERSION=2.1.2
WORKDIR $BASE_PATH

# 设置JVM参数
ENV JAVA_TOOL_OPTIONS="-Dmirai.console.skip-end-user-readme"

# 安装所需的工具
RUN apt-get update && apt-get install -y \
    unzip \
    wget \
    primus-libs \
    fonts-noto \
    iputils-ping && \
    rm -rf /var/lib/apt/lists/*

# 添加字体文件
COPY HarmonyOS_Sans_Regular.ttf /usr/share/fonts/

# 安装 Google 字体
RUN wget https://github.com/google/fonts/archive/main.tar.gz -O gf.tar.gz && \
    tar -xf gf.tar.gz && \
    mkdir -p /usr/share/fonts/truetype/google-fonts && \
    find $PWD/fonts-main/ -name "*.ttf" -exec install -m644 {} /usr/share/fonts/truetype/google-fonts/ \; || return 1 && \
    rm -f gf.tar.gz && \
    fc-cache -f && \
    rm -rf $PWD/fonts-main/

# mcl
RUN wget https://github.com/MrXiaoM/mirai-console-loader/releases/download/v2.1.2-patch1/with-overflow.zip && \
    unzip with-overflow.zip && \
    rm with-overflow.zip && \
    chmod +x ./mcl && \
    
    # install plugins
    ./mcl --update-package net.mamoe:chat-command --channel maven-stable --type plugin && \
#    ./mcl --update-package xyz.cssxsh.mirai:mirai-skia-plugin --channel maven-stable --type plugins && \
    ./mcl --update-package top.colter:bilibili-dynamic-mirai-plugin --channel maven --type plugin && \
    
    # initial start
    ./mcl -u --dry-run && \
    
    # Clean up
    apt-get purge -y unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
#    ./mcl -u

CMD ["./mcl", "-u"]
