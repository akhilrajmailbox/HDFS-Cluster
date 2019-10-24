# Hadoop Distributed File System (HDFS)-Cluster On AKS

**Tested on Azure, This deployment will work in any other cloud but have to change the configurations for storageclass and loadbalancer configurations**

## What is HDFS?

* Namenode
	* NameNode is the centerpiece of  HDFS.
	* NameNode is also known as the Master
	* NameNode only stores the metadata of HDFS – the directory tree of all files in the file system, and tracks the files across the cluster.
	* NameNode does not store the actual data or the dataset. The data itself is actually stored in the DataNodes.
	* NameNode knows the list of the blocks and its location for any given file in HDFS. With this information NameNode knows how to construct the file from blocks.
	* NameNode is so critical to HDFS and when the NameNode is down, HDFS/Hadoop cluster is inaccessible and considered down.
	* NameNode is a single point of failure in Hadoop cluster.
	* NameNode is usually configured with a lot of memory (RAM). Because the block locations are help in main memory.

* DataNode
	* DataNode is responsible for storing the actual data in HDFS.
	* DataNode is also known as the Slave
	* NameNode and DataNode are in constant communication.
	* When a DataNode starts up it announce itself to the NameNode along with the list of blocks it is responsible for.
	* When a DataNode is down, it does not affect the availability of data or the cluster. NameNode will arrange for replication for the blocks managed by the DataNode that is not available.
	* DataNode is usually configured with a lot of hard disk space. Because the actual data is stored in the DataNode.



## Current software

* Alpine Linux 3.5
* OpenJDK 8
* Hadoop 3.2.1


## Kubernetes Cluster Requirement

* cluster of 3 worker nodes (HA Configuration)
* medium / high IOPS Required for the vm type
* 4vcpu and 16 GB RAM for each worker ndoes
* premium Storageclass needed for better performance


## HDFS Cluster Features

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
| HDFS_MASTER_URL | hdfs-master |
| DATA_REPLICA | 1 |
| DATANODE_NAME | localhost |



## Kubernetes Deployment 

**Run these commands from `Kubernetes` Folder**


### Create Namespace for Elasticsearch Deployment
```
kubectl apply -f hdfs-namespace.yaml
```

### create fast storageclass (for datanode)
```
kubectl apply -f disk-storageclass.yaml
kubectl get storageclass
```

### create azure files storageclass (for namenode)
```
kubectl apply -f azure-file-storageclass.yaml
kubectl get storageclass
kubectl apply -f azure-file-pvc-roles.yaml
```


### Deploy namenodes
```
kubectl apply -f hdfs-namenode-pvc.yaml
kubectl apply -f hdfs-namenode-deployment.yaml
kubectl apply -f hdfs-namenode-service.yaml
kubectl -n hdfs-cluster get pods
```

### Deploy datanodes
```
kubectl apply -f hdfs-datanode-deployment.yaml
kubectl -n hdfs-cluster get pods
```


**You can check the status for the hdfs cluster by accessing the service withc we created in namenode section (hdfs-webui)**


## Easy Commands

* to list all nodes in HDFS cluster (run within the cluster)
```
hadoop dfsadmin -report
```

* service management on hdfs cluster
```
hadoop-daemon.sh start [namenode | secondarynamenode | datanode | jobtracker | tasktracker]
```

* hdfs url to access 
```
hdfs://<namenode>:<ipc_port>

example : hdfs://10.50.144.32:9000/
```

* Test write access to the Hadoop cluster

* Listing Files in HDFS
```
hadoop fs -ls hdfs://10.50.144.32:9000/
```

* Inserting Data into HDFS (Transfer and store a data file from local systems to the Hadoop file system using the put command)
```
hadoop fs -mkdir hdfs://10.50.144.32:9000/user/input 
hadoop fs -put /path/to/file.txt hdfs://10.50.144.32:9000/user/input
hadoop fs -ls hdfs://10.50.144.32:9000/user/input
```

* Retrieving Data from HDFS
```
hadoop fs -cat hdfs://10.50.144.32:9000/user/input/file.txt
hadoop fs -get hdfs://10.50.144.32:9000/user/input/file.txt /tmp/
```

**If Hadoop CLI does not return an error message, then your setup is correct**





## Reference Docs

[reference](https://www.linode.com/docs/databases/hadoop/how-to-install-and-set-up-hadoop-cluster/)

[reference](https://www.tutorialspoint.com/hadoop/hadoop_multi_node_cluster.htm)

[reference-on-kubernetes](https://blog.hasura.io/getting-started-with-hdfs-on-kubernetes-a75325d4178c/#f452)

[reference-disk-balancer](https://dzone.com/articles/how-to-use-the-new-hdfs-intra-datanode-disk-balanc)

[hadoop-cluster](https://www.edureka.co/blog/how-to-set-up-hadoop-cluster-with-hdfs-high-availability/)

[secondary-namenodes](http://blog.madhukaraphatak.com/secondary-namenode---what-it-really-do/)

[hadoop-cli](https://docs.splunk.com/Documentation/HadoopConnect/1.2.5/DeployHadoopConnect/HadoopCLI)

[hadoop-tutorialspoint](https://www.tutorialspoint.com/hadoop/hadoop_hdfs_operations.htm)