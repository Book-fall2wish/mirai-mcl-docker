FROM ibm-semeru-runtimes:open-17-jre-focal

ENV TZ Asia/Shanghai
ENV BASE_PATH=/home/mirai
ENV MCL_VERSION=2.1.2
WORKDIR $BASE_PATH

RUN cd $BASE_PATH && \
    apt update && \
    apt install -y unzip curl primus-libs && \
    curl -OL https://github.com/iTXTech/mirai-console-loader/releases/download/v${MCL_VERSION}/mcl-${MCL_VERSION}.zip && \
    unzip mcl-${MCL_VERSION}.zip && \
    rm mcl-${MCL_VERSION}.zip && \
    chmod +x ./mcl u && \

    # Clean up
    apt-get purge -y unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["./mcl"]
