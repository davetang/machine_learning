#!/usr/bin/env bash

set -euo pipefail

path=$(dirname $0)
cd ${path}/..

check_depend (){
   tool=$1
   if [[ ! -x $(command -v ${tool}) ]]; then
     >&2 echo Could not find ${tool}
     exit 1
   fi
}

dependencies=(docker)
for tool in ${dependencies[@]}; do
   check_depend ${tool}
done

now(){
   date '+%Y/%m/%d %H:%M:%S'
}

SECONDS=0

>&2 printf "[ %s %s ] Start job\n\n" $(now)

r_version=4.1.3
docker_image=davetang/r_build:${r_version}
USERID=$(id -u) \
GROUPID=$(id -g) \

docker run \
   --rm \
   -v $(pwd):$(pwd) \
   -w $(pwd) \
   ${docker_image} \
   find . -user root -exec chown ${USERID}:${GROUPID} {} \;

>&2 printf "\n[ %s %s ] Work complete\n" $(now)

duration=$SECONDS
>&2 echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

exit 0

