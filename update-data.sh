#!/bin/bash

set -e

source .env

Rscript get-mpp-sheet.R
Rscript scrape-eopa.R
Rscript process-data.R
./tile-data.sh
./update-r2.sh
