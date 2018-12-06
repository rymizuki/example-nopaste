FROM perl:5.28.0-slim

RUN apt-get update \
 && apt-get install -y gcc \
 && apt-get install -y default-libmysqlclient-dev
RUN cpanm Carton

WORKDIR /usr/local/docker/app

COPY ./cpanfile /usr/local/docker/app/cpanfile
COPY ./cpanfile.snapshot /usr/local/docker/app/cpanfile.snapshot
COPY ./bin /usr/local/docker/app/bin
COPY ./lib /usr/local/docker/app/lib
COPY ./app.pl /usr/local/docker/app/app.pl
COPY ./dependency-injection.yml /usr/local/docker/app/dependency-injection.yml

RUN carton install

CMD ./bin/start