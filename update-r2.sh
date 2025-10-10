#!/bin/bash

aws s3 cp data/temp/tiles/districts.pmtiles s3://polluters-pay-tiles \
  --endpoint-url $S3_API
