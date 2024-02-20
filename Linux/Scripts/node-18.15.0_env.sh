#!/bin/bash

curr_script=$(realpath "${BASH_SOURCE[0]}")
path_to_add=${devenver_root}/NodeJS/18.15.0/bin
echo [DEVENVER] \"${curr_script}\" is adding to path \"${path_to_add}\"

PATH=${path_to_add}:${PATH} $@

