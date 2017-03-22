FROM gethue/hue:latest
MAINTAINER Pär Tjärnberg <par.tjarnberg@cygni.se>

# Add configuration
ADD ./hue.ini /hue/desktop/conf/
ADD ./hbase-site.xml /etc/hbase/conf/
ADD ./hdfs-site.xml /etc/hadoop/conf/
ADD ./core-site.xml /etc/hadoop/conf/