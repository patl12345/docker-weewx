FROM debian:stretch-slim

ENV WEEWX_VERSION 3.9.1-1
ENV OWFS_VERSION 0.21


RUN apt-get update && apt-get install -y \
wget \
owfs \
ow-shell \
python-ow \
python-mysqldb \
procps \
vim

RUN mkdir /tmp/setup
WORKDIR /tmp/setup
RUN wget http://www.weewx.com/downloads/released_versions/weewx_${WEEWX_VERSION}_all.deb
RUN dpkg -i weewx_${WEEWX_VERSION}_all.deb || apt-get -y --no-install-recommends -f install
RUN rm weewx_${WEEWX_VERSION}_all.deb

RUN wget http://lancet.mit.edu/mwall/projects/weather/releases/weewx-owfs-${OWFS_VERSION}.tgz
RUN wee_extension --install weewx-owfs-${OWFS_VERSION}.tgz
RUN rm weewx-owfs-${OWFS_VERSION}.tgz

RUN cp /tmp/config/weewx.conf /etc/weewx/
RUN cp -R /tmp/config/skins/Byteweather /etc/weewx/skins/ 

ENTRYPOINT service weewx start
