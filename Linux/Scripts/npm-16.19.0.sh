#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

desired_dir=${script_dir}/../NodeJS/16.19.0/bin
desired_exe=${desired_dir}/npm
PATH=${desired_dir}:${PATH}

curr_script=$(realpath "${BASH_SOURCE[0]}")
echo [DEVENVER] Executing script \"${curr_script}\" with \"${desired_exe}\"

${desired_exe} $@

