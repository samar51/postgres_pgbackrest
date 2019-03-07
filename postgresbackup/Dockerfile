FROM debian:9

RUN apt-get update && apt-get install -y wget openssh-server sudo cron \
    && wget https://github.com/pgbackrest/pgbackrest/archive/release/2.08.tar.gz && tar zfx 2.08.tar.gz -C /root/ \
    && apt-get install -y build-essential libssl-dev libxml2-dev libperl-dev zlib1g-dev  openssh-client \
    && make -s -C /root/pgbackrest-release-2.08/src && apt-get remove -y  build-essential libssl-dev libxml2-dev libperl-dev zlib1g-dev wget \
    && apt-get -y autoremove && apt-get clean  && apt-get install -y libdbd-pg-perl && rm -rf /var/lib/apt/lists/*

RUN cp /root/pgbackrest-release-2.08/src/pgbackrest /usr/bin && chmod 755 /usr/bin/pgbackrest

RUN useradd -ms /bin/bash pgbackrest

RUN mkdir -p -m 770 /var/log/pgbackrest && chown pgbackrest:pgbackrest /var/log/pgbackrest \
    && mkdir -p /etc/pgbackrest && mkdir -p /etc/pgbackrest/conf.d \
    && chown -R pgbackrest:pgbackrest /etc/pgbackrest \
    && touch /etc/pgbackrest/pgbackrest.conf && chmod 640 /etc/pgbackrest/pgbackrest.conf \
    && chown  pgbackrest:pgbackrest /etc/pgbackrest/pgbackrest.conf

#RUN cp -pr /etc/init.d/ssh /usr/sbin/sshd

RUN echo "pgbackrest   ALL=(ALL:ALL) NOPASSWD: /usr/sbin/sshd" >>/etc/sudoers
RUN echo "pgbackrest   ALL=(ALL:ALL) NOPASSWD: /usr/sbin/cron" >>/etc/sudoers
RUN echo "pgbackrest   ALL=(ALL:ALL) NOPASSWD: /bin/chown" >>/etc/sudoers

RUN  mkdir /run/sshd

ADD fullbackup /etc/cron.d/fullbackup
RUN chmod 0644 /etc/cron.d/fullbackup
RUN crontab /etc/cron.d/fullbackup

ADD diffrentialbackup /etc/cron.d/diffrentialbackup
RUN chmod 0644 /etc/cron.d/diffrentialbackup
RUN crontab /etc/cron.d/diffrentialbackup

ADD crontest /etc/cron.d/crontest
RUN chmod 0644 /etc/cron.d/crontest
RUN crontab /etc/cron.d/crontest


RUN mkdir -p /var/lib/pgbackrest/ && chown -R pgbackrest:pgbackrest /var/lib/pgbackrest/

USER pgbackrest
RUN mkdir /home/pgbackrest/.ssh && chmod 700 /home/pgbackrest/.ssh && touch /home/pgbackrest/.ssh/known_hosts && chmod 644 /home/pgbackrest/.ssh/known_hosts
ENV PATH="~/.local/bin:${PATH}"
EXPOSE  22

ADD script.sh /home/pgbackrest/

ENTRYPOINT [ "/bin/bash","/home/pgbackrest/script.sh" ]
CMD tail -f /dev/null
#USER postgres

