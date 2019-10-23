FROM alpine:3.5
MAINTAINER Akhil Raj

# Export HTTP & Transport
EXPOSE 9000 22
ENV HDFS_VERSION 3.2.1

RUN apk add --no-cache --update bash su-exec util-linux curl ca-certificates wget openssh openjdk8 openrc
RUN apk add openrc --no-cache
RUN rc-update add sshd
RUN rc-status
RUN touch /run/openrc/softlevel
RUN echo "PasswordAuthentication no" >>  /etc/ssh/sshd_config

#Java configuration
ENV JAVA_HOME "/usr/lib/jvm/java-1.8-openjdk"

# RUN adduser -s /bin/bash -g "User for managing of HDFS" -h /home/hadoop hadoop | echo ""
# RUN echo -e "mypassword\nmypassword" | passwd hadoop
# USER hadoop
# WORKDIR /home/hadoop
# RUN ssh-keygen -f /home/hadoop/.ssh/id_rsa -q -P ""
# RUN cat /home/hadoop/.ssh/id_rsa.pub > /home/hadoop/.ssh/authorized_keys

## root user
USER root
WORKDIR /home/hadoop
RUN ssh-keygen -f /root/.ssh/id_rsa -q -P ""
RUN cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys


#https://hadoop.apache.org/releases.html
ENV DOWNLOAD_URL "https://www.apache.org/dist/hadoop/common/hadoop-${HDFS_VERSION}"
ENV HDFS_TARBAL "${DOWNLOAD_URL}/hadoop-${HDFS_VERSION}.tar.gz"

RUN wget $HDFS_TARBAL
RUN tar -xf hadoop-${HDFS_VERSION}.tar.gz && rm -rf hadoop-${HDFS_VERSION}.tar.gz
RUN mv hadoop-${HDFS_VERSION} hadoop
ENV HADOOP_HOME "/home/hadoop/hadoop"
ENV PATH "$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin"
# USER root
ADD entrypoint.sh /home/hadoop/entrypoint.sh
RUN chmod a+x /home/hadoop/entrypoint.sh

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk" >> /etc/profile
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk" >>${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_HOME=/home/hadoop/hadoop" >> /etc/profile
RUN echo "export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin" >> /etc/profile

ENV HDFS_MASTER true
ENV HDFS_MASTER_URL node-master
ENV DATA_REPLICA 1
ENV DATANODE_NAME localhost

CMD ["/etc/init.d/sshd", "start"]
ENTRYPOINT [ "/home/hadoop/entrypoint.sh" ]