FROM sequenceiq/hadoop-docker:2.7.1
MAINTAINER Pär Tjärnberg <par.tjarnberg@cygni.se>

# Add configuration
ADD ./hdfs-site.xml /usr/local/hadoop/etc/hadoop/
ADD ./core-site.xml /usr/local/hadoop/etc/hadoop/

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

CMD ["/etc/bootstrap.sh", "-d"]