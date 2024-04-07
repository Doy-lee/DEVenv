#!/bin/bash
curr_script=$(realpath "${BASH_SOURCE[0]}")
path_to_add=${devenver_root}/CMake/3.29.1/bin
echo [DEVENVER] \"${curr_script}\" is adding to path \"${path_to_add}\"

PATH=${path_to_add}:${PATH} $@
