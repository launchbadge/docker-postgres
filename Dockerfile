# https://registry.hub.docker.com/u/phusion/baseimage/
FROM phusion/baseimage:latest
MAINTAINER launchbadge <contact@launchbadge.com>

ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD docker

# build and select UTF-8 locale for postgres
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
ENV LANG en_US.utf8

RUN apt-get update && \
    apt-get install -y --force-yes postgresql-9.3 postgresql-contrib && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./start.sh /srv/start.sh
ADD ./postgresql.conf /srv/postgresql.conf

ENV PGDATA /var/lib/postgresql/data
ENV PGBIN /usr/lib/postgresql/9.3/bin

VOLUME ["/var/lib/postgresql/data"]
VOLUME ["/run/postgresql"]

EXPOSE 5432
ENTRYPOINT ["/srv/start.sh"]
