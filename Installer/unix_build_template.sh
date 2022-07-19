script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
compiler_list=(gcc clang)

for compiler in "${compiler_list[@]}"
do
    version_list=()
    if [[ "${compiler}" == "gcc" ]]; then
        version_list+=(12.1.0)
        version_list+=(11.3.0)
        version_list+=(9.5.0)
        cxx_compiler=g++
        c_compiler=gcc
    elif [[ "${compiler}" == "clang" ]]; then
        version_list+=(14.0.0)
        cxx_compiler=clang++
        c_compiler=clang
    fi

    for version in "${version_list[@]}"
    do
        if [[ "${compiler}" == "gcc" ]];then
            cmake_flags="-D CMAKE_BUILD_RPATH='/home/doyle/Developer/Tools/gcc-mostlyportable/gcc-mostlyportable-${version}/usr/lib64/'"
        fi

        build_dir=${script_dir}/build/${compiler}-${version}

    done
    cp --force ${build_dir}/compile_commands.json .
done

