#
# OsmTirex
# Image including tirex and apache to render OSM data.
#


FROM mytracks/osmbase:latest
MAINTAINER "Dirk Stichling" <mytracks@mytracks4mac.com>

RUN mkdir /osmstyles

COPY osmstyles/ /osmstyles/
COPY ld.so.local.conf /etc/ld.so.conf.d/local.conf

RUN yum -y install httpd

RUN yum -y install epel-release \
&& rpm -ivh http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm \
&& yum -y install proj sqlite libjpeg-turbo libtiff libwebp postgresql95 postgis2_95 postgresql95 libpqxx harfbuzz gdal cairo boost perl-Sys-Syslog perl-JSON perl-IPC-ShareLite perl-GD perl-libwww-perl

COPY mapnik-3.0.9-1.el7.centos.x86_64.rpm /tmp/
COPY modtile-1.0.0-1.el7.centos.x86_64.rpm /tmp/
COPY tirex-1.0.0-1.el7.centos.x86_64.rpm /tmp/

RUN rpm -Uvh /tmp/mapnik-3.0.9-1.el7.centos.x86_64.rpm \
&& rpm -Uvh /tmp/modtile-1.0.0-1.el7.centos.x86_64.rpm \
&& rpm -Uvh /tmp/tirex-1.0.0-1.el7.centos.x86_64.rpm \
&& ldconfig \
&& rm /tmp/*.rpm

COPY tirex.conf /etc/tirex/
COPY mapnik.conf /etc/tirex/renderer/
COPY osm*.conf /etc/tirex/renderer/mapnik/
COPY start.sh /etc/

RUN mkdir /var/run/tirex \
&& chown gis.gis /var/run/tirex \
&& mkdir /var/lib/tirex \
&& mkdir /var/lib/tirex/stats \
&& chown -R gis.gis /var/lib/tirex \
&& mkdir /var/log/tirex \
&& chown gis.gis /var/log/tirex \
&& rm -rf /etc/tirex/renderer/mapserver* /etc/tirex/renderer/test* /etc/tirex/renderer/wms*

COPY mod_tile.conf /etc/httpd/conf.d/

# Clean up
RUN yum clean all

EXPOSE 80

VOLUME /tiles

# Set the default command to run when starting the container
ENTRYPOINT ["/etc/start.sh"]

