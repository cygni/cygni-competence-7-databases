FROM debian:jessie
ENV DEBIAN_FRONTEND noninteractive

# Configure backports
RUN apt-get -qq update

# Install prereqs
RUN apt-get --no-install-recommends -y install \
    build-essential \
    ca-certificates \
    curl \
    erlang-dev \
    erlang-nox \
    git \
    libicu-dev \
    libmozjs185-dev \
    python \
    wget

# Get couchdb
RUN wget -nv http://apache.mirrors.spacedump.net/couchdb/source/2.0.0/apache-couchdb-2.0.0.tar.gz
RUN mkdir -p /home/couchdb
RUN tar -xf apache-couchdb-2.0.0.tar.gz --strip 1 -C /home/couchdb
RUN useradd -m couchdb
WORKDIR /home/couchdb

# We don't to be so strict for simple testing.
RUN sed -i'' '/require_otp_vsn/d' rebar.config.script

# Expose nodes on external network interface
RUN sed -i'' 's/bind_address = 127.0.0.1/bind_address = 0.0.0.0/' rel/overlay/etc/default.ini

# Build
RUN ./configure
RUN make couch

EXPOSE 15984 25984 35984 15986 25986 35986
ENTRYPOINT ["/home/couchdb/dev/run", "--with-admin-party-please"]
