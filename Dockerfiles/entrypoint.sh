#!/bin/bash

function core_site_conf() {
cat << EOF > /home/hadoop/hadoop/etc/hadoop/core-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
    <configuration>
        <property>
            <name>fs.default.name</name>
            <value>hdfs://${HDFS_MASTER_URL}:9000</value>
        </property>
    </configuration>
EOF
}


function hdfs_site_conf() {
    core_site_conf
cat << EOF > /home/hadoop/hadoop/etc/hadoop/hdfs-site.xml
<configuration>
    <property>
            <name>dfs.namenode.name.dir</name>
            <value>/home/hadoop/data/nameNode</value>
            <final>true</final>
    </property>

    <property>
            <name>dfs.datanode.data.dir</name>
            <value>/home/hadoop/data/dataNode</value>
            <final>true</final>
    </property>

    <property>
            <name>dfs.namenode.datanode.registration.ip-hostname-check</name>
            <value>false</value>
    </property>

    <property>
            <name>dfs.disk.balancer.enabled</name>
            <value>true</value>
    </property>

    <property>
            <name>dfs.replication</name>
            <value>${DATA_REPLICA}</value>
    </property>
</configuration>
EOF
}


function service_start() {
    hdfs_site_conf
    ## start ssh services
    /etc/init.d/sshd start
    if [[ ${HDFS_MASTER} == true ]] ; then
        # echo "" > /home/hadoop/hadoop/etc/hadoop/workers
        yes n | hdfs namenode -format
        hadoop-daemon.sh start namenode
    else
        # echo "$DATANODE_NAME" > /home/hadoop/hadoop/etc/hadoop/workers
        hadoop-daemon.sh start datanode
    fi
}


function health_check() {
    service_start
    if [[ ${HDFS_MASTER} == true ]] ; then
        export Node_Status=$(jps | grep NameNode)
    else
        export Node_Status=$(jps | grep DataNode)
    fi
    export SSH_Status=$(ps -ef | grep sshd)
    while true ; do
        if [[ -z ${Node_Status} ]] || [[ -z ${SSH_Status} ]] ; then
            echo "Either hdfs node (NameNode or DataNode) and ssh are not running.... Task aborting...!"
            exit 1
        fi
    done
}


health_check