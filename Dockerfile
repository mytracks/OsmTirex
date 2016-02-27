#
# OsmTirex
# Image including tirex and apache to render OSM data.
#

FROM mytracks/osmbase:latest
MAINTAINER "Dirk Stichling" <mytracks@mytracks4mac.com>

RUN mkdir /osmstyles

COPY osmstyles/ /osmstyles/
COPY ld.so.local.conf /etc/ld.so.conf.d/local.conf

RUN yum -y install epel-release
RUN yum -y install gdal gdal-devel git gcc-c++ make harfbuzz-devel cairo-devel

RUN cd ~ \
&& mkdir tmp \
&& cd tmp \
&& curl -O https://mapnik.s3.amazonaws.com/dist/v3.0.9/mapnik-v3.0.9.tar.bz2 \
&& tar jxf mapnik-v3.0.9.tar.bz2 \
&& cd mapnik-v3.0.9 \
&& ./configure \
&& make \
&& make install \
&& cd ~ \
&& rm -rf tmp \
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
CMD ["/etc/start.sh"]

