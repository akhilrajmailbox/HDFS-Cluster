FROM akhilrajmailbox/elasticsearch:docker-jre-8u171_alpine_3.8.1
MAINTAINER Akhil Raj

# Export HTTP & Transport
EXPOSE 9000
ENV HDFS_VERSION 3.1.2

#https://hadoop.apache.org/releases.html
ENV DOWNLOAD_URL "https://www.apache.org/dist/hadoop/common/hadoop-${HDFS_VERSION}/"
ENV ES_TARBAL "${DOWNLOAD_URL}/hadoop-${HDFS_VERSION}.tar.gz"

