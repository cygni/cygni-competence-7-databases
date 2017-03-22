# HBase
HBase is an implementation of Google's Bigtable. It is built on top of Hadoop and HDFS. Because of the strong relationship with Hadoop we will first have a short introduction into Hadoop and some of its key components before digging into HBase. Furthermore we will look into Hue which is useful when working with and analysing data within HBase.

## Table of Contents
* [Resources](#resources)
* [Preparations](#preparations)
    * [Create network](#create-network)
    * [Start Zookeeper+Hadoop+HBase+Hue](#start-zk-hdp-hbase-hue)
    * [Check logs](#check-logs)
    * [Check ps](#check-ps)
    * [Check stats](#check-stats)
    * [Run HBase shell](#run-hbase-shell)
    * [Browse HUE](#browse-hue)
    * [Browse HDFS](#browse-hdfs)
* [Exercises](#exercises)
    * [Getting used to the HBase shell](#getting-used-to-the-hbase-shell)
    * [Streaming media into HBase](#streaming-media-into-hbase)

## <a name="resource"></a>Resources
* HBase - [http://hbase.apache.org/](http://hbase.apache.org)
* Hadoop - [http://hadoop.apache.org/](http://hadoop.apache.org)
* HDFS - [https://wiki.apache.org/hadoop/HDFS](https://wiki.apache.org/hadoop/HDFS)
* Zookeeper - [http://zookeeper.apache.org/](http://zookeeper.apache.org)
* Hue - [http://gethue.com/](http://gethue.com)

## <a name="preparations"></a>Preparations
Before we start make sure you have cloned the repository to a directory of choice.
```
git clone http://github.com/cygni/cygni-competence-7-databases
```
### <a name="create-network"></a>Create network
```
$ docker network create --driver=bridge vnet
ba4b3a73006145d3b5346b19c019351b0d33bd228ed20f2da50f0193507b1b02
$ docker network ls
```
__Sample output:__
```
NETWORK ID     NAM      DRIVER      SCOPE
ba4b3a730061   vnet     bridge      local
```
### <a name="start-zk-hdp-hbase-hue"></a>Start Zookeeper+Hadoop+HBase+Hue
```
docker-compose up -d --build
```
__Sample output:__
```
Pulling zookeeper (wurstmeister/zookeeper:latest)...
latest: Pulling from wurstmeister/zookeeper
a3ed95caeb02: Pull complete
ef38b711a50f: Downloading [===============================>                   ] 42.71 MB/67.5 MB
e057c74597c7: Download complete
666c214f6385: Download complete
c3d6a96f1ffc: Download complete
3fe26a83e0ca: Download complete
3d3a7dd3a3b1: Downloading [==========>                                        ] 23.25 MB/109.9 MB
f8cc938abe5f: Download complete
9978b75f7a58: Download complete
4d4dbcc8f8cc: Download complete
6e2141080cee: Download complete
7b01624d9a37: Download complete
438e659516b8: Waiting
...
...
Building hadoop
Step 1/8 : FROM sequenceiq/hadoop-docker:2.7.1
 ---> 42efa33d1fa3
...
...
Creating zookeeper
Creating hadoop
Creating hbase
Creating hue
```

### <a name="check-logs"></a>Check logs
```
docker-compose logs -f
```
### <a name="check-ps"></a>Check ps
```
docker-compose ps
```
__Sample output:__
```
     Name                            Command                           State                     Ports                      
------------------------------------------------------------------------------------------------------------------------
hadoop                        /etc/bootstrap.sh -d                      Up                0.0.0.0:9000->9000/tcp                          
hbase                         /bin/sh -c "/usr/local/hba ...            Up                0.0.0.0:9090->9090/tcp  
hue                           ./build/env/bin/hue runser ...            Up                0.0.0.0:8888->8888/tcp                          
zookeeper                     /bin/sh -c /usr/sbin/sshd  ...            Up                0.0.0.0:2181->2181/tcp       
```

### <a name="check-stats"></a>Check stats
```
Run: docker ps --format {{.Names}} | xargs docker stats
```
__Sample output:__
```
CONTAINER   CPU %    MEM USAGE / LIMIT       MEM %     NET I/O             BLOCK I/O           PIDS
hue         2.47%    148.5 MiB / 1.952 GiB   7.43%     3.44 MB / 41.8 MB   97.2 MB / 29 MB     3
hbase       0.62%    336.4 MiB / 1.952 GiB   16.83%    737 kB / 866 kB     167 MB / 147 kB     60
hadoop      4.43%    944.6 MiB / 1.952 GiB   47.25%    778 kB / 1.02 MB    176 MB / 6.52 MB    409
zookeeper   0.21%    75.96 MiB / 1.952 GiB   3.80%     405 kB / 330 kB     39 MB / 340 kB      21
```
### <a name="run-hbase-shell"></a>Run HBase shell
Verify you can access hbase shell by running the following command:
```
docker exec -it hbase bash -c "hbase shell"
```
__Sample output:__
```
Version 1.2.4, r67592f3d062743907f8c5ae00dbbe1ae4f69e5af, Tue Oct 25 18:10:20 CDT 2016

hbase(main):001:0> 
```
Type _exit_ to leave hbase shell.

### <a name="browse-hue"></a>Browse HUE
Verify you can visit [http://localhost:8888/hbase](http://localhost:8888/hbase)

![alt text][hue-first-page]

When prompted for username/password then enter:

username: __hue__
password: __hue__

![alt text][hue-hbase-page]

### <a name="browse-hdfs"></a>Browse HDFS
Verify you can visit [http://localhost:50070/explorer.html](http://localhost:50070/explorer.html)

![alt text][hadooop-hdfs-explorer-page]

## <a name="excercises"></a>Exercises
### <a name="getting-used-to-the-hbase-shell"></a>Getting used to the HBase shell
1. Figure out how to use the shell to do the following:
    * Delete individual column values within a row
    * Delete an entire row
    
2. Create a function called _put_many()_ that creates a Put instance, adds any number of column-value pairs to it, and commit it to a table. The signature should look like this:
    ```jruby
    def put_many( table_name, row, column_values)
        # your code here
    end
    ```

3. Define your _put_many()_ function by pasting it in the HBase shell, and then call it like so:
    ```jruby
    hbase> put_many 'wiki', 'Some title',  {
    hbase*  "text:" => "Some article text",
    hbase*  "revision:author" => "jschmoe",
    hbase*  "revision:comment" => "no comment"}
    ```
   
### <a name="streaming-media-into-hbase"></a>Streaming media into HBase    
1. Download, extract and feed HBase with wikipedia data via the following command:
    ```jruby
    curl https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2 | bzcat | \
    ${HBASE_HOME}/bin/hbase shell import_from_wikipedia.rb
    ```
    You should see output like this eventually:
    ```
    500 records inserted (Ashmore and Cartier Islands)
    1000 records inserted (Annealing)
    1500 records inserted (Ajanta Caves)
    ...
    ```
    You probably want to shut it down after a while. Just press Ctrl+C

[hue-first-page]: https://github.com/partjarnberg/cygni-competence-7-databases/blob/screenshots/hbase/hue-first-page.png?raw=true "Hue First Page"
[hue-hbase-page]: https://github.com/partjarnberg/cygni-competence-7-databases/blob/screenshots/hbase/hue-hbase-page.png?raw=true "Hue Hbase Page"
[hadooop-hdfs-explorer-page]: https://github.com/partjarnberg/cygni-competence-7-databases/blob/screenshots/hbase/hadoop-hdfs-explorer-page.png?raw=true "Hue Hbase Page"