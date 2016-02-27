#!/bin/sh

sed -e 's/file="symbols/file="symbols2x/g' -e 's/<Map /<Map buffer-size="256" /g' -e 's/avoid-edges="false"/avoid-edges="true" clip="true"/g' -e 's/<TextSymbolizer/<TextSymbolizer avoid-edges="true"/g' -e 's/minimum-distance="30"/minimum-distance="60"/g' -e 's/<PointSymbolizer/& transform="scale(0.5)"/g' -e 's/<ShieldSymbolizer/& minimum-padding="25" avoid-edges="true" transform="scale(0.5)"/g' -e 's/avoid-edges="true" >/ >/g' osm.xml >osm2x.xml

sed -e 's/file="symbols/file="symbols4x/g' -e 's/<Map /<Map buffer-size="256" /g' -e 's/avoid-edges="false"/avoid-edges="true" clip="true"/g' -e 's/<TextSymbolizer/<TextSymbolizer avoid-edges="true"/g' -e 's/minimum-distance="30"/minimum-distance="60"/g' -e 's/<PointSymbolizer/& transform="scale(0.25)"/g' -e 's/<ShieldSymbolizer/& minimum-padding="50" avoid-edges="true" transform="scale(0.25)"/g' -e 's/avoid-edges="true" >/ >/g' osm.xml >osm4x.xml

