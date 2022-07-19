#!/bin/bash

for gcc_version in "$@"
do
    image_name=mostlyportable-gcc-image
    container_name=mostlyportable-gcc

    docker build -t ${image_name} --build-arg GCC_VERSION=${gcc_version} . || exit
    docker container rm ${container_name} > /dev/null 2>&1
    docker create --name ${container_name} ${image_name} || exit

    mkdir --parent build || exit
    docker cp ${container_name}:/usr/local/docker/gcc-mostlyportable-${gcc_version} . || exit

    docker container rm ${container_name} || exit
done

if [[ $EUID == 0 ]]; then
    chown --recursive ${USER} build
fi
