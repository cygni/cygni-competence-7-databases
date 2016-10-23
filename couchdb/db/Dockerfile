FROM debian:jessie
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update
RUN apt-get --no-install-recommends -y install \
    build-essential pkg-config erlang \
    libicu-dev libmozjs185-dev libcurl4-openssl-dev \
    wget

RUN wget -nv http://apache.mirrors.spacedump.net/couchdb/source/2.0.0/apache-couchdb-2.0.0.tar.gz
RUN tar -xf apache-couchdb-2.0.0.tar.gz
WORKDIR ./apache-couchdb-2.0.0
RUN ./configure; make release; cp -r rel/couchdb /couchdb
WORKDIR /couchdb
RUN sed -i'' 's/bind_address = 127.0.0.1/bind_address = 0.0.0.0/' etc/default.ini
RUN sed -i'' 's/port = 5984/port = 80/' etc/default.ini

EXPOSE 80
ENTRYPOINT ["/couchdb/bin/couchdb"]