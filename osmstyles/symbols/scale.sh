#!/bin/sh

cp ../../mapnik/symbols/*.png .

for f in *.png
do
	echo $f
	convert -scale '200%' $f $f
done
