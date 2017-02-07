# Image based on postgres with code examples and javascript capabilities
# Build with docker build -t postgres-client .

FROM postgres:9.6
# RUN mkdir /code
COPY code /code
RUN apt-get update && apt-get -y install postgresql-9.6-plv8
