#!/bin/bash

curr_script=$(realpath "${BASH_SOURCE[0]}")
path_to_add=${devenver_root}/NodeJS/12.22.12/bin
echo [DEVENVER] \"${curr_script}\" is adding to path \"${path_to_add}\"

PATH=${path_to_add}:${PATH} $@

