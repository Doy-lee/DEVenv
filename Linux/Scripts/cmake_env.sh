#!/bin/bash

curr_script=$(realpath "${BASH_SOURCE[0]}")
root_path=${devenver_root}/CMake
path_to_add=${root_path}/$1/bin

if [ "$1" == "list" ]; then
    ls ${root_path}
else
    echo [DEVENVER] \"${curr_script}\" is adding to path \"${path_to_add}\"
    PATH=${path_to_add}:${PATH} ${@:2}
fi

