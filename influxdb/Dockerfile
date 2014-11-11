FROM phusion/baseimage:0.9.15

ADD build/buildconfig /build/buildconfig

ADD config/ /etc/

ADD build/influxdb /build/influxdb
RUN /build/influxdb/install

ADD service/. /etc/service/

EXPOSE 8083 8086 8084

VOLUME ["/data"]

CMD ["/sbin/my_init"]
