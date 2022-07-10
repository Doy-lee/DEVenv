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

# CMake
# ----------------------------------------------------------------------------
cmake_sha256=aaced6f745b86ce853661a595bdac6c5314a60f8181b6912a0a4920acfa32708
cmake_exe_sha256=95b80ba2b97b619abce1ed6fd28fe189cacba48403e9c69256f2f94e3405e645
cmake_version=3.23.2

cmake_label=cmake_linux64_${cmake_version}
cmake_download_file=${downloads_dir}/${cmake_label}.tar.gz
cmake_dir=${tools_dir}/${cmake_label}
cmake_exe=${cmake_dir}/bin/cmake

if [[ ! -f "${cmake_exe}" ]]; then
    DownloadFile "https://github.com/Kitware/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}-linux-x86_64.tar.gz" "${cmake_download_file}" || exit
    FileSHA256Check "${cmake_download_file}" "${cmake_sha256}" || exit
    mkdir --parents "${cmake_dir}" && tar xf "${cmake_download_file}" --overwrite --directory="${cmake_dir}" || exit
    echo "mv --force ${cmake_dir}/cmake-${cmake_version}-linux-x86_64 "${cmake_dir}""
    mv ${cmake_dir}/cmake-${cmake_version}-linux-x86_64/* "${cmake_dir}" || exit
    rm --recursive ${cmake_dir}/cmake-${cmake_version}-linux-x86_64 || exit
fi

FileSHA256Check "${cmake_exe}" "${cmake_exe_sha256}" || exit
cd "${bin_dir}" && ln --force --symbolic --relative "${cmake_exe}" cmake                  && cd "${root_dir}"
cd "${bin_dir}" && ln --force --symbolic --relative "${cmake_exe}" cmake-${cmake_version} && cd "${root_dir}"

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

# Nvim
# ------------------------------------------------------------------------------
nvim_sha256=33b5d020c730b6d1b5185b1306ead83b6b8f8fab0239e0580c72b5224a9658e1
nvim_version=0.7.2

nvim_label=nvim_linux64_${nvim_version}
nvim_exe=${tools_dir}/${nvim_label}.appimage

DownloadFile "https://github.com/neovim/neovim/releases/download/v${nvim_version}/nvim.appimage" "${nvim_exe}" || exit
FileSHA256Check "${nvim_exe}" "${nvim_sha256}" || exit

chmod +x "${nvim_exe}"
cd "${bin_dir}" && ln --force --symbolic --relative "${nvim_exe}" nvim && cd "${root_dir}"
cd "${bin_dir}" && ln --force --symbolic --relative "${nvim_exe}" vim  && cd "${root_dir}"

# Neovide
# ----------------------------------------------------------------------------
neovide_sha256=684cbcaeb2e67f1d95822ef80e03e1475395d537f2032f47b8202fe48c428b08
neovide_exe_sha256=e4fbc8b56af2e25127938ae2974921e25b4df5722086d7e8c3e517e8ee86e2df
neovide_version=0.9.0

neovide_label=neovide_linux64_${neovide_version}
neovide_download_file=${downloads_dir}/${neovide_label}.tar.gz
neovide_dir=${tools_dir}
neovide_exe=${neovide_dir}/${neovide_label}

if [[ ! -f "${neovide_exe}" ]]; then
    DownloadFile "https://github.com/neovide/neovide/releases/download/${neovide_version}/neovide.tar.gz" ${neovide_download_file} || exit
    FileSHA256Check ${neovide_download_file} ${neovide_sha256} || exit

    mkdir --parents "${cmake_dir}" && tar xf ${neovide_download_file} --overwrite --directory=${neovide_dir}/neovide-tmp || exit
    mv ${neovide_dir}/neovide-tmp/target/release/neovide "${neovide_exe}" || exit
    rm -rf ${neovide_dir}/neovide-tmp
fi

FileSHA256Check ${neovide_exe} ${neovide_exe_sha256} || exit
cd "${bin_dir}" && ln --force --symbolic --relative "${neovide_exe}" neovide && cd "${root_dir}"

# Ctags
# ------------------------------------------------------------------------------
rm --force ${bin_dir}/ctags_cpp.sh
echo ctags --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ \$\@ >> ${bin_dir}/ctags_cpp.sh
chmod +x ${bin_dir}/ctags_cpp.sh

echo PATH=${tools_dir}/Binaries:\$\{PATH\}> ${tools_dir}/linux_terminal.sh

