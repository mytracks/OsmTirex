#
# OsmTirex
# Image including tirex and apache to render OSM data.
#

FROM mytracks/osmbase:latest
MAINTAINER "Dirk Stichling" <mytracks@mytracks4mac.com>

RUN mkdir /osmstyles

COPY osmstyles/ /osmstyles/
COPY ld.so.local.conf /etc/ld.so.conf.d/local.conf

RUN yum -y install epel-release \
&& rpm -ivh http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm \
&& yum -y install proj sqlite libjpeg-turbo libtiff libwebp postgresql95 postgis2_95 postgresql95 libpqxx harfbuzz gdal cairo boost \
&& yum -y install libicu-devel sqlite-devel proj-devel libjpeg-turbo-devel libtiff-devel libwebp-devel postgis2_95-devel postgresql95-devel libpqxx-devel harfbuzz-devel gdal-devel cairo-devel boost-devel

COPY mapnik-3.0.9-1.el7.centos.x86_64.rpm /tmp/

RUN rpm -Uvh /tmp/mapnik-3.0.9-1.el7.centos.x86_64.rpm \
&& ldconfig

RUN cd /osmstyles && ./get-shapefiles.sh

RUN yum -y install perl-Sys-Syslog perl-JSON perl-IPC-ShareLite perl-GD perl-libwww-perl perl-ExtUtils-MakeMaker \
&& cd ~ \
&& mkdir tmp \
&& cd tmp \
&& git clone https://github.com/geofabrik/tirex/ \
&& cd tirex \
&& make \
&& make install \
&& cd ~ \
&& rm -rf tmp

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

#
# Apache
#

RUN yum -y install httpd httpd-devel

#
# mod_tile
#

USER root

RUN cd ~ \
&& mkdir tmp \
&& cd tmp \
&& git clone https://github.com/openstreetmap/mod_tile/ \
&& cd mod_tile \
&& ./autogen.sh \
&& ./configure \
&& sed -i.bak 's/define MAX_ZOOM .*/define MAX_ZOOM 22/g' includes/render_config.h \
&& make \
&& make install \
&& make install-mod_tile \
&& ldconfig \
&& cd ~ \
&& rm -rf tmp

COPY mod_tile.conf /etc/httpd/conf.d/

# Clean up
RUN yum clean all

EXPOSE 80

VOLUME /tiles

# Set the default command to run when starting the container
ENTRYPOINT ["/etc/start.sh"]

