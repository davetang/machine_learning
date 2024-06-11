#!/usr/bin/env bash

set -euo pipefail

VER=4.4.0
IMG=davetang/r_tensorflow:${VER}
CONTAINER=rstudio_server_r_tensorflow
PORT=8883
RLIB=${HOME}/r_packages_${VER}

if [[ ! -d ${RLIB} ]]; then
   mkdir ${RLIB}
fi

docker run \
   --name ${CONTAINER} \
   -d \
   --rm \
   -p ${PORT}:8787 \
   -v ${RLIB}:/packages \
   -v ${HOME}/github/:/home/rstudio/work \
   -e PASSWORD=password \
   -e USERID=$(id -u) \
   -e GROUPID=$(id -g) \
   ${IMG}

>&2 echo ${CONTAINER} listening on port ${PORT}

exit 0
