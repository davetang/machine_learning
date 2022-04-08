#!/usr/bin/env bash

set -euo pipefail

num_param=1

usage(){
   echo "Usage: $0 <file.Rmd>"
   exit 1
}

if [[ $# -ne ${num_param} ]]; then
   usage
fi

infile=$1
if [[ ! -e ${infile} ]]; then
  >&2 echo ${infile} does not exist
  exit 1
fi

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

>&2 printf "[ %s %s ] Start job" $(now)

img_dir=$(cat ${infile} | grep "knitr::opts_chunk\$set(fig.path" | cut -f2 -d '=' | sed 's/[")]//g;s/\/\n$//')

r_version=4.1.3
docker_image=davetang/r_build:${r_version}
package_dir=${HOME}/r_packages_${r_version}

if [[ ! -d ${package_dir} ]]; then
   mkdir ${package_dir}
fi

docker run \
   --rm \
   -v ${package_dir}:/packages \
   -v $(pwd):$(pwd) \
   -w $(pwd) \
   -e USERID=$(id -u) \
   -e GROUPID=$(id -g) \
   ${docker_image} \
   Rscript -e "rmarkdown::render('${infile}', output_file = 'README.md')"
#   Rscript -e ".libPaths('packages/'); rmarkdown::render('${infile}', output_file = 'README.md')"

>&2 printf "\n[ %s %s ] Work complete\n" $(now)

duration=$SECONDS
>&2 echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

exit 0

