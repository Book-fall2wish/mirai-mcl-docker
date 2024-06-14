# mirai-mcl-docker
mcl（mirai-console-loader）的Docker镜像

mirai项目地址：https://github.com/mamoe/mirai
overflow项目地址：https://github.com/MrXiaoM/Overflow

本项目仅将mirai和overflow插件整合至docker中运行
&nbsp;

#以下为原作者内容
## 介绍

由于更换服务器，需要重新部署Mirai，故借此机会创建Docker镜像方便后续使用。

Dockerfile如下：基于ibm-semeru的openjdk 17镜像；设置时区、设置mcl安装位置为/home/mirai、从[iTXTech/mirai-console-loader](https://github.com/iTXTech/mirai-console-loader/releases)项目处下载mcl.zip文件、解压、修改执行权限、并安装[chat-command](https://docs.mirai.mamoe.net/ConsoleTerminal.html#%E5%A6%82%E4%BD%95%E5%AE%89%E8%A3%85%E5%AE%98%E6%96%B9%E6%8F%92%E4%BB%B6)插件；运行镜像执行`./mcl`命令。

```dockerfile
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
```

&nbsp;

本镜像没有安装[mirai-api-http](https://docs.mirai.mamoe.net/ConsoleTerminal.html#%E5%A6%82%E4%BD%95%E5%AE%89%E8%A3%85%E5%AE%98%E6%96%B9%E6%8F%92%E4%BB%B6)插件，如有需要，可自行更改Dockerfile创建镜像。

&nbsp;

## 使用

**载入镜像**

本项目已发布成品镜像文件，可以直接使用；也可利用Dockerfile自行构建镜像。

以2.1.2版本镜像文件为例：

* 直接使用镜像文件：从本项目Releases处下载镜像文件，并运行`docker load -i mcl-2.1.2.tar`
* 自行构建镜像：下载/复制Dockerfile文件（并自定义修改文件内容），在该目录位置执行`docker build -t mcl:2.1.2 .`

至此，镜像已载入本地。

&nbsp;

**运行镜像**

由于mcl的I/O比较奇怪 ~~（不太会I/O知识）~~ ，暂无法做到对一个mcl容器的多次I/O链接，故mcl容器的运行如下：

* 需要在控制台交互操作mcl时，运行`docker run -it --name mcl -v mcl:/home/mirai mcl:2.1.2` 
* 不需要交互操作，仅需mcl后台执行即可时，运行`docker run -d --name mcl -v mcl:/home/mirai mcl:2.1.2`
* 需要重启容器时，先停止容器`stop`或`docker stop mcl`（视启动方式而定），再删除容器`docker rm mcl`，最后运行镜像启动容器`docker run -it/-d --name mcl -v mcl:/home/mirai mcl:2.1.2`；由于有volume持久化，所以容器被删除重建也不影响后续运行

&nbsp;

**修改Mirai**

在上述运行命令中，创建了数据卷`mcl`，其在容器中对应`/home/mirai`目录，该目录是mcl的安装目录，包含了mcl的所有文件。所以可以通过修改宿主机的`/var/lib/docker/volumes/mcl/_data`目录下的内容，实现修改容器内mcl内容。该目录下就是完整的mcl组件，与寻常使用mcl无异。

&nbsp;

**特点**

~~(一通操作下来也没简便多少)~~ 

传统通过ssh在服务器直接运行`./mcl`的方法，关闭本地命令行窗口后，服务器的进程也被终止。即使`-d`执行，也存在一些问题。（也可能是我不太会）

通过Docker运行mcl，执行`docker run -d ...`命令后，关闭ssh窗口也不影响服务器上的容器运行。

&nbsp;

如有任何疑问/建议，欢迎issue/联系。

