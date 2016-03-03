#!/bin/sh

sed 's#<Parameter name="dbname"><!\[CDATA\[gis\]\]><\/Parameter>#<Parameter name="dbname"><![CDATA[gis]]></Parameter><Parameter name="user"><![CDATA[gis]]></Parameter><Parameter name="host"><![CDATA[osmpostgres]]></Parameter><Parameter name="port"><![CDATA[5432]]></Parameter><Parameter name="password"><![CDATA[gis]]></Parameter>#g' orig/osm.xml > osm.xml
sed 's#<Parameter name="dbname"><!\[CDATA\[gis\]\]><\/Parameter>#<Parameter name="dbname"><![CDATA[gis]]></Parameter><Parameter name="user"><![CDATA[gis]]></Parameter><Parameter name="host"><![CDATA[osmpostgres]]></Parameter><Parameter name="port"><![CDATA[5432]]></Parameter><Parameter name="password"><![CDATA[gis]]></Parameter>#g' orig/osm2x.xml > osm2x.xml
sed 's#<Parameter name="dbname"><!\[CDATA\[gis\]\]><\/Parameter>#<Parameter name="dbname"><![CDATA[gis]]></Parameter><Parameter name="user"><![CDATA[gis]]></Parameter><Parameter name="host"><![CDATA[osmpostgres]]></Parameter><Parameter name="port"><![CDATA[5432]]></Parameter><Parameter name="password"><![CDATA[gis]]></Parameter>#g' orig/osm4x.xml > osm4x.xml

