FROM postgres:9.6

RUN apt-get update && apt-get install -y wget python python-pip openssh-server sudo  && pip install patroni[etcd] && pip install psycopg2-binary && patronictl version \
    && wget https://github.com/pgbackrest/pgbackrest/archive/release/2.08.tar.gz && tar zfx 2.08.tar.gz -C /root/ \
    && apt-get install -y build-essential libssl-dev libxml2-dev libperl-dev zlib1g-dev openssh-client \
    && make -s -C /root/pgbackrest-release-2.08/src && apt-get remove -y  build-essential libssl-dev libxml2-dev libperl-dev zlib1g-dev wget \
    && apt-get -y autoremove && apt-get clean  && apt-get install -y libdbd-pg-perl && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /home/postgres \
    && chown postgres:postgres /home/postgres
RUN mkdir /data/ && touch /pgpass \
    && chown postgres:postgres -R /data/ /pgpass /var/run/ /var/lib/ /var/log/

RUN cp /root/pgbackrest-release-2.08/src/pgbackrest /usr/bin && chmod 755 /usr/bin/pgbackrest


RUN mkdir -p -m 770 /var/log/pgbackrest && chown postgres:postgres /var/log/pgbackrest \
    && mkdir -p /etc/pgbackrest && mkdir -p /etc/pgbackrest/conf.d \
    && touch /etc/pgbackrest/pgbackrest.conf && chmod 640 /etc/pgbackrest/pgbackrest.conf \
    && chown postgres:postgres /etc/pgbackrest/pgbackrest.conf
RUN usermod -u 999 postgres && groupmod -g 999 postgres
#RUN cp -pr /etc/init.d/ssh /usr/bin/sshd

RUN chown -R postgres:postgres /etc/pgbackrest
RUN mkdir -p /data/dbnode1 && chown -R postgres:postgres /data/dbnode1
RUN mkdir -p /data/dbnode2 && chown -R postgres:postgres /data/dbnode2

RUN echo "postgres   ALL=(ALL:ALL) NOPASSWD: /usr/sbin/sshd" >>/etc/sudoers
RUN echo "postgres   ALL=(ALL:ALL) NOPASSWD: /bin/chown" >>/etc/sudoers
RUN mkdir /run/sshd
USER postgres

ENV PATH="~/.local/bin:${PATH}"
EXPOSE 5432 8008 22
#USER root
RUN mkdir /var/lib/postgresql/.ssh && chmod 700 /var/lib/postgresql/.ssh && touch /var/lib/postgresql/.ssh/known_hosts && chmod 644 /var/lib/postgresql/.ssh/known_hosts
ADD script.sh /var/lib/postgresql/

ENTRYPOINT [ "/bin/bash","/var/lib/postgresql/script.sh" ]
CMD tail -f /dev/null
#USER postgres

