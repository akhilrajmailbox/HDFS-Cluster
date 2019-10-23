# HDFS-Cluster On AKS

**Tested on Azure, This deployment will work in any other cloud but have to change the configurations for storageclass and loadbalancer configurations**

[reference](https://www.linode.com/docs/databases/hadoop/how-to-install-and-set-up-hadoop-cluster/)

[reference](https://www.tutorialspoint.com/hadoop/hadoop_multi_node_cluster.htm)

[reference-on-kubernetes](https://blog.hasura.io/getting-started-with-hdfs-on-kubernetes-a75325d4178c/#f452)

[reference-disk-balancer](https://dzone.com/articles/how-to-use-the-new-hdfs-intra-datanode-disk-balanc)


# Current software

* Alpine Linux 3.5
* OpenJDK 8
* Hadoop 3.2.1


# Kubernetes Cluster Requirement

* cluster of 3 worker nodes (HA Configuration)
* medium / high IOPS Required for the vm type
* 4vcpu and 16 GB RAM for each worker ndoes
* premium Storageclass needed for better performance


# HDFS Cluster Features

* High Available (HA) Cluster on Kubernetes
* Self Healing Configuration for all nodes (datanode and namenode)
* anytime can scale the cluster size (both horizontal and vertical)
* Authentication between nodes enabled with ssh and passwordless
* The default cluster have the following components (can be increase the number anytime without downtime)
	* Three namenode nodes
 	* Three datanode nodes


### Environment variables

This image can be configured by means of environment variables, that one can set on a `Deployment`.

| Variable Name | Default Value |
|---------------|---------------|
| HDFS_MASTER | true |
| HDFS_MASTER_URL | node-master |
| DATA_REPLICA | 1 |
| DATANODE_NAME | localhost |

