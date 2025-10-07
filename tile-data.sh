#!/bin/bash

# GeoJSON → MBTiles
tippecanoe --force -zg -o data/temp/tiles/districts.mbtiles \
  -L assembly:data/temp/assembly.geojson \
  -L senate:data/temp/senate.geojson

# MBTiles → PMTiles
pmtiles convert data/temp/tiles/districts.mbtiles data/temp/tiles/districts.pmtiles
