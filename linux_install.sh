#!/usr/bin/env bash

# Functions
# ------------------------------------------------------------------------------
DownloadFile()
{
    url=$1
    dest_file=$2

    if [[ -f "${dest_file}" ]]; then
        echo "- [DownloadFile/Cached] ${url} to ${dest_file}"
    else
        echo "- [DownloadFile] ${url} to ${dest_file}"
        wget --output-document ${dest_file} ${url}
        if [ $? -ne 0 ]; then
            echo "- [DownloadFile] Download failed [url=${url}]"
            exit
        fi
    fi
}

FileSHA256Check()
{
    file=$1
    expected=$2

    echo "${expected} ${file}" | sha256sum --check
    if [[ $? -ne 0 ]]; then
        echo "- [FileSHA256Check] Failed [file=${file}, "
        echo "    expect=${expected}  ${file},"
        echo "    actual=$(sha256sum ${file})"
        echo "  ]"
        exit
    else
        echo "- [FileSHA256Check] OK [file=${file}, hash=${expected}]"
    fi
}

# Setup
# ------------------------------------------------------------------------------
root_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

home_dir=${root_dir}/Home
installer_dir=${root_dir}/Installer
tools_dir=${root_dir}/Tools
downloads_dir=${root_dir}/Downloads
mkdir --parents ${home_dir}
mkdir --parents ${tools_dir}
mkdir --parents ${downloads_dir}

bin_dir=${tools_dir}/Binaries
mkdir --parents ${bin_dir}

# Tools
# ------------------------------------------------------------------------------
if ! command -v docker &> /dev/null
then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
fi

# CMake
# ----------------------------------------------------------------------------
cmake_sha256=aaced6f745b86ce853661a595bdac6c5314a60f8181b6912a0a4920acfa32708
cmake_exe_sha256=95b80ba2b97b619abce1ed6fd28fe189cacba48403e9c69256f2f94e3405e645
cmake_version=3.23.2

cmake_download_name=cmake-${cmake_version}-linux-x86_64
cmake_download_file=${cmake_download_name}.tar.gz
cmake_download_path=${downloads_dir}/${cmake_download_file}

cmake_label=cmake_linux64_${cmake_version}
cmake_dir=${tools_dir}/${cmake_label}
cmake_exe=${cmake_dir}/bin/cmake

if [[ ! -f "${cmake_exe}" ]]; then
    DownloadFile "https://github.com/Kitware/CMake/releases/download/v${cmake_version}/${cmake_download_file}" "${cmake_download_path}" || exit
    FileSHA256Check "${cmake_download_path}" "${cmake_sha256}" || exit
    mkdir --parents "${cmake_dir}" && tar xf "${cmake_download_path}" --skip-old-files --directory="${cmake_dir}" || exit
    mv ${cmake_dir}/cmake-${cmake_version}-linux-x86_64/* "${cmake_dir}" || exit
    rm --recursive ${cmake_dir}/cmake-${cmake_version}-linux-x86_64 || exit
fi

FileSHA256Check "${cmake_exe}" "${cmake_exe_sha256}" || exit

cd "${cmake_dir}/bin" && find . -type f,l -exec ln --force --symbolic --relative "{}" "${bin_dir}/{}-${cmake_version}" ';' && cd "${root_dir}"
cd "${cmake_dir}/bin" && find . -type f,l -exec ln --force --symbolic --relative "{}" "${bin_dir}/" ';'                    && cd "${root_dir}"

# FD
# ------------------------------------------------------------------------------
fd_sha256=a1e72cf4f4fbd1b061387569678f3ab3555ee1cf025280b3ce6b2eee96cd3210
fd_exe_sha256=057bea03a6f17eb99ea3b11c25a110880b012d2d5110988e80b1ce2ee6536342
fd_version=8.4.0

fd_download_name=fd-v${fd_version}-x86_64-unknown-linux-gnu
fd_download_file=${fd_download_name}.tar.gz
fd_download_path=${downloads_dir}/${fd_download_file}

fd_dir=${tools_dir}/fd_linux64_${fd_version}
fd_exe=${fd_dir}/fd

if [[ ! -f "${fd_exe}" ]]; then
    DownloadFile "https://github.com/sharkdp/fd/releases/download/v${fd_version}/${fd_download_file}" "${fd_download_path}" || exit
    FileSHA256Check "${fd_download_path}" "${fd_sha256}" || exit
    mkdir --parents "${fd_dir}" && tar xf "${fd_download_path}" --skip-old-files --directory="${fd_dir}" || exit
    mv ${fd_dir}/${fd_download_name}/* "${fd_dir}" || exit
    rm --recursive ${fd_dir}/${fd_download_name} || exit
fi

FileSHA256Check "${fd_exe}" "${fd_exe_sha256}" || exit
ln --force --symbolic --relative "${fd_exe}" "${bin_dir}"

# GCC
# ------------------------------------------------------------------------------
gcc_dir=${tools_dir}/gcc-mostlyportable
gcc_version_list=()
gcc_version_list+=(6.5.0)
gcc_version_list+=(7.5.0)
gcc_version_list+=(8.5.0)
gcc_version_list+=(9.5.0)
gcc_version_list+=(10.4.0)
gcc_version_list+=(11.3.0)
gcc_version_list+=(12.1.0)

mkdir --parents "${gcc_dir}"
cp "${installer_dir}/unix_gcc_build.sh"   "${gcc_dir}/build.sh"
cp "${installer_dir}/unix_gcc_dockerfile" "${gcc_dir}/Dockerfile"

cd "${gcc_dir}" || exit
    for gcc_version in ${gcc_version_list[@]}; do
        gcc_bin_dir=${gcc_dir}/gcc-mostlyportable-${gcc_version}/bin
        if [[ ! -f "${gcc_bin_dir}/g++" ]]; then
            ./build.sh ${gcc_version} || exit
        fi
        ln --symbolic --force --relative ${gcc_bin_dir}/g++ ${bin_dir}/g++-${gcc_version} || exit
        ln --symbolic --force --relative ${gcc_bin_dir}/gcc ${bin_dir}/gcc-${gcc_version} || exit
    done
    ln --symbolic --force --relative "${gcc_bin_dir}/g++" "${bin_dir}/g++" || exit
    ln --symbolic --force --relative "${gcc_bin_dir}/gcc" "${bin_dir}/gcc" || exit
cd "${root_dir}" || exit

# LLVM/Clang
# ------------------------------------------------------------------------------
llvm_version_list=()
llvm_version_list+=(11.1.0)
llvm_version_list+=(12.0.1)
llvm_version_list+=(13.0.1)
llvm_version_list+=(14.0.0)

for llvm_version in ${llvm_version_list[@]}; do
    llvm_sha256=none
    llvm_exe_sha256=none
    if [[ "${llvm_version}" == "14.0.0" ]]; then
        llvm_sha256=61582215dafafb7b576ea30cc136be92c877ba1f1c31ddbbd372d6d65622fef5
        llvm_exe_sha256=3557c2deadae7e2bc3bffce4afd93ddab6ef50090971c8ce3bf15c80b27134a0
        llvm_download_name=clang+llvm-${llvm_version}-x86_64-linux-gnu-ubuntu-18.04
    elif [[ "${llvm_version}" == "13.0.1" ]]; then
        llvm_sha256=84a54c69781ad90615d1b0276a83ff87daaeded99fbc64457c350679df7b4ff0
        llvm_exe_sha256=ae47e6cc9f6d95f7a39e4800e511b7bdc3f55464ca79e45cd63cbd8a862a82a1
        llvm_download_name=clang+llvm-${llvm_version}-x86_64-linux-gnu-ubuntu-18.04
    elif [[ "${llvm_version}" == "12.0.1" ]]; then
        llvm_sha256=6b3cc55d3ef413be79785c4dc02828ab3bd6b887872b143e3091692fc6acefe7
        llvm_exe_sha256=329bba976c0cef38863129233a4b0939688eae971c7a606d41dd0e5a53d53455
        llvm_download_name=clang+llvm-${llvm_version}-x86_64-linux-gnu-ubuntu-16.04
    elif [[ "${llvm_version}" == "11.1.0" ]]; then
        llvm_sha256=c691a558967fb7709fb81e0ed80d1f775f4502810236aa968b4406526b43bee1
        llvm_exe_sha256=656bfde194276cee81dc8a7a08858313c5b5bdcfa18ac6cd6116297af2f65148
        llvm_download_name=clang+llvm-${llvm_version}-x86_64-linux-gnu-ubuntu-16.04
    fi

    llvm_download_file=${llvm_download_name}.tar.xz
    llvm_download_path=${downloads_dir}/${llvm_download_name}.tar.xz

    llvm_dir=${tools_dir}/llvm_linux64_${llvm_version}
    llvm_exe=${llvm_dir}/bin/clang

    if [[ ! -f "${llvm_exe}" ]]; then
        DownloadFile "https://github.com/llvm/llvm-project/releases/download/llvmorg-${llvm_version}/${llvm_download_file}" "${llvm_download_path}" || exit
        FileSHA256Check "${llvm_download_path}" "${llvm_sha256}" || exit
        mkdir --parents "${llvm_dir}" && tar xf "${llvm_download_path}" --skip-old-files --directory="${llvm_dir}" || exit

        if [[ "${llvm_version}" == "12.0.1" ]]; then
            # NOTE: There was a distribution bug in v12.0.1 where the folder was misnamed
            mv ${llvm_dir}/clang+llvm-${llvm_version}-x86_64-linux-gnu-ubuntu-/* ${llvm_dir} || exit
            rm --recursive ${llvm_dir}/clang+llvm-${llvm_version}-x86_64-linux-gnu-ubuntu- || exit
        else
            mv ${llvm_dir}/${llvm_download_name}/* ${llvm_dir} || exit
            rm --recursive ${llvm_dir}/${llvm_download_name} || exit
        fi
    fi
    FileSHA256Check "${llvm_exe}" "${llvm_exe_sha256}" || exit
    cd "${llvm_dir}/bin" && find . -type f,l -exec ln --force --symbolic --relative "{}" "${bin_dir}/{}-${llvm_version}" ';' && cd "${root_dir}"
done

cd "${llvm_dir}/bin" && find . -type f,l -exec ln --force --symbolic --relative "{}" "${bin_dir}/" ';' && cd "${root_dir}"

# gf
# ------------------------------------------------------------------------------
gf_dir=${tools_dir}/gf

if [[ ! -d "${gf_dir}" ]]; then
    git clone https://github.com/nakst/gf "${tools_dir}/gf" || exit
fi

cd "${tools_dir}/gf" || exit
git checkout master

# Use our custom G++ because I typically run Ubuntu 18.04 which uses G++7
# which is too old to compile GF.
PATH=${gcc_bin_dir}:${PATH} ./build.sh || exit
ln --force --symbolic --relative "gf2" "${bin_dir}"

cd "${root_dir}"

# Vim Configuration
# ------------------------------------------------------------------------------
cp --force ${installer_dir}/os_vimrc ~/.vimrc || exit
cp --force ${installer_dir}/os_clang_format_style_file ~/_clang-format || exit

# Nvim Config
nvim_init_dir=~/.config/nvim
mkdir --parents "${nvim_init_dir}"
cp --force ${installer_dir}/os_nvim_init.vim ${nvim_init_dir}/init.vim || exit

# Vim Package Manager
vim_plug_dir=${nvim_init_dir}/autoload
vim_plug=${vim_plug_dir}/plug.vim
mkdir --parents ${vim_plug_dir}
DownloadFile "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" "${vim_plug}" || exit

# nodejs
# ----------------------------------------------------------------------------
nodejs_sha256=f0867d7a17a4d0df7dbb7df9ac3f9126c2b58f75450647146749ef296b31b49b
nodejs_exe_sha256=8fdc420e870ef9aa87dc8c1b7764fccb8229b6896f112b699afeeefeb0021714
nodejs_version=16.17.0

nodejs_download_name=node-v${nodejs_version}-linux-x64
nodejs_download_file=${nodejs_download_name}.tar.xz
nodejs_download_path=${downloads_dir}/${nodejs_download_file}

nodejs_dir=${tools_dir}/nodejs_linux64_${nodejs_version}
nodejs_exe=${nodejs_dir}/bin/node

if [[ ! -f "${nodejs_exe}" ]]; then
    DownloadFile "https://nodejs.org/dist/v${nodejs_version}/${nodejs_download_file}" ${nodejs_download_path} || exit
    FileSHA256Check ${nodejs_download_path} ${nodejs_sha256} || exit

    mkdir --parents "${nodejs_dir}" && tar xf "${nodejs_download_path}" --skip-old-files --directory="${nodejs_dir}" || exit
    mv ${nodejs_dir}/${nodejs_download_name}/* "${nodejs_dir}" || exit
    rm --recursive ${nodejs_dir}/${nodejs_download_name}
fi

FileSHA256Check ${nodejs_exe} ${nodejs_exe_sha256} || exit
ln --force --symbolic --relative "${nodejs_exe}" "${bin_dir}/node" || exit
ln --force --symbolic --relative "${nodejs_dir}/bin/npm" "${bin_dir}/npm" || exit

# Nvim
# ------------------------------------------------------------------------------
nvim_sha256=33b5d020c730b6d1b5185b1306ead83b6b8f8fab0239e0580c72b5224a9658e1
nvim_version=0.7.2

nvim_label=nvim_linux64_${nvim_version}
nvim_exe=${tools_dir}/nvim_linux64_${nvim_version}.AppImage

DownloadFile "https://github.com/neovim/neovim/releases/download/v${nvim_version}/nvim.appimage" "${nvim_exe}" || exit
FileSHA256Check "${nvim_exe}" "${nvim_sha256}" || exit

chmod +x "${nvim_exe}"
ln --force --symbolic --relative "${nvim_exe}" "${bin_dir}/nvim"
ln --force --symbolic --relative "${nvim_exe}" "${bin_dir}/vim"

# Neovide
# ----------------------------------------------------------------------------
neovide_sha256=684cbcaeb2e67f1d95822ef80e03e1475395d537f2032f47b8202fe48c428b08
neovide_exe_sha256=e4fbc8b56af2e25127938ae2974921e25b4df5722086d7e8c3e517e8ee86e2df
neovide_version=0.9.0

neovide_download_name=neovide
neovide_download_file=${neovide_download_name}.tar.gz
neovide_download_path=${downloads_dir}/${neovide_download_name}.tar.gz

neovide_dir=${tools_dir}
neovide_exe=${neovide_dir}/neovide_linux64_${neovide_version}

if [[ ! -f "${neovide_exe}" ]]; then
    DownloadFile "https://github.com/neovide/neovide/releases/download/${neovide_version}/${neovide_download_file}" ${neovide_download_path} || exit
    FileSHA256Check ${neovide_download_path} ${neovide_sha256} || exit

    mkdir --parents ${neovide_dir}/neovide-tmp && tar xf ${neovide_download_path} --skip-old-files --directory=${neovide_dir}/neovide-tmp || exit
    mv ${neovide_dir}/neovide-tmp/target/release/neovide "${neovide_exe}" || exit
    rm -rf ${neovide_dir}/neovide-tmp
fi

FileSHA256Check ${neovide_exe} ${neovide_exe_sha256} || exit
ln --force --symbolic --relative "${neovide_exe}" "${bin_dir}/neovide"

# Python 3
# ------------------------------------------------------------------------------
python_sha256=460f87a389be28c953c24c6f942f172f9ce7f331367b4daf89cb450baedd51d7
python_exe_sha256=1400cb8f2cf2f606d1c87c1edb69ea1b3479b4c2bfb5c438a4828903a1d6f9f8
python_version=3.10.5

python_download_name=cpython-${python_version}+20220630-x86_64-unknown-linux-gnu-install_only
python_download_file=${python_download_name}.tar.gz
python_download_path=${downloads_dir}/${python_download_file}

python_dir=${tools_dir}/python_linux64_${python_version}
python_exe=${python_dir}/bin/python3

if [[ ! -f "${python_exe}" ]]; then
    DownloadFile "https://github.com/indygreg/python-build-standalone/releases/download/20220630/${python_download_file}" "${python_download_path}" || exit
    FileSHA256Check "${python_download_path}" "${python_sha256}" || exit
    mkdir --parents "${python_dir}" && tar xf "${python_download_path}" --skip-old-files --directory="${python_dir}" || exit
    mv --force ${python_dir}/python/* "${python_dir}" || exit
    rm --recursive ${python_dir}/python || exit
fi

FileSHA256Check "${python_dir}/bin/python3" "${python_exe_sha256}" || exit
ln --force --symbolic --relative "${python_dir}/bin/python3" "${bin_dir}"
ln --force --symbolic --relative "${python_dir}/bin/python3" "${bin_dir}/python-${python_version}"
ln --force --symbolic --relative "${python_dir}/bin/pip" "${bin_dir}"
ln --force --symbolic --relative "${python_dir}/bin/pip" "${bin_dir}/pip-${python_version}"

${python_dir}/bin/pip install pynvim cmake-language-server

# Ripgrep
# ------------------------------------------------------------------------------
ripgrep_sha256=ee4e0751ab108b6da4f47c52da187d5177dc371f0f512a7caaec5434e711c091
ripgrep_exe_sha256=4ef156371199b3ddac1bf584e0e52b1828279af82e4ea864b4d9c816adb5db40
ripgrep_version=13.0.0

ripgrep_download_name=ripgrep-${ripgrep_version}-x86_64-unknown-linux-musl
ripgrep_download_file=${ripgrep_download_name}.tar.gz
ripgrep_download_path=${downloads_dir}/${ripgrep_download_file}

ripgrep_dir=${tools_dir}/ripgrep_linux64_${ripgrep_version}
ripgrep_exe=${ripgrep_dir}/rg

if [[ ! -f "${ripgrep_exe}" ]]; then
    DownloadFile "https://github.com/BurntSushi/ripgrep/releases/download/${ripgrep_version}/${ripgrep_download_file}" "${ripgrep_download_path}" || exit
    FileSHA256Check "${ripgrep_download_path}" "${ripgrep_sha256}" || exit
    mkdir --parents "${ripgrep_dir}" && tar xf "${ripgrep_download_path}" --skip-old-files --directory="${ripgrep_dir}" || exit
    mv ${ripgrep_dir}/${ripgrep_download_name}/* "${ripgrep_dir}" || exit
    rm --recursive ${ripgrep_dir}/${ripgrep_download_name} || exit
fi

FileSHA256Check "${ripgrep_exe}" "${ripgrep_exe_sha256}" || exit
ln --force --symbolic --relative "${ripgrep_exe}" "${bin_dir}"

# wezterm
# ------------------------------------------------------------------------------
wezterm_sha256=4de3cd65b7d7ae0c72a691597bd3def57c65f07fe4a7c98b447b8a9dc4d0adf0
wezterm_version=20220624-141144-bd1b7c5d

wezterm_download_name=WezTerm-${wezterm_version}-Ubuntu18.04
wezterm_download_file=${wezterm_download_name}.AppImage
wezterm_exe=${tools_dir}/wezterm_linux64_${wezterm_version}.AppImage

DownloadFile "https://github.com/wez/wezterm/releases/download/${wezterm_version}/${wezterm_download_file}" ${wezterm_exe} || exit
FileSHA256Check "${wezterm_exe}" "${wezterm_sha256}" || exit

chmod +x "${wezterm_exe}"
cp --force ${installer_dir}/os_wezterm.lua ~/.wezterm.lua

# Ctags
# ------------------------------------------------------------------------------
rm --force ${bin_dir}/ctags_cpp.sh
echo ctags --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ \$\@ >> ${bin_dir}/ctags_cpp.sh
chmod +x ${bin_dir}/ctags_cpp.sh

# Linux Terminal
# ------------------------------------------------------------------------------
echo \#!/usr/bin/env bash> ${tools_dir}/linux_terminal.sh
echo PATH=${tools_dir}/Binaries>> ${tools_dir}/linux_terminal.sh
echo PATH=\$\{PATH\}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin>> ${tools_dir}/linux_terminal.sh
echo [[ -d /usr/lib/wsl/lib ]] \&\& PATH=\$\{PATH\}:/usr/lib/wsl/lib>> ${tools_dir}/linux_terminal.sh
echo [[ -d /snap/bin ]] \&\& PATH=\$\{PATH\}:/snap/bin>> ${tools_dir}/linux_terminal.sh


