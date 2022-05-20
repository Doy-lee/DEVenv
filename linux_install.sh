#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------
DownloadFile()
{
    url=$1
    dest_file=$2

    if [[ -f "${dest_file}" ]]; then
        echo "- [Download] [Cached] ${url} to ${dest_file}"
    else
        wget --output-document ${dest_file} ${url}
        if [ $? -ne 0 ]; then
            echo "Failed to download file from ${url}"
            exit
        fi
    fi
}

FileSHA256HashCheck()
{
    file=$1
    expected=$2

    echo "${expected} ${file}" | sha256sum --check
    if [[ $? -ne 0 ]]; then
        echo "- [Verify] ${file} "
        echo "Expected: ${expected}"
        echo "Actual: $(sha256sum ${file})"
        exit
    else
        echo "- [Verify] Hash OK: ${file} ${expected}"
    fi
}

# ------------------------------------------------------------------------------
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

vim_dir=${HOME}/.vim
vim_plug_dir=${vim_dir}/autoload
mkdir --parents ${vim_plug_dir}
mkdir --parents ${bin_dir}
mkdir --parents ~/.config/nvim

# ------------------------------------------------------------------------------
# Tools
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------
sudo apt install exuberant-ctags neovim clang-format

# ------------------------------------------------------------------------------
# Vim Configuration
# ------------------------------------------------------------------------------
# Vim Package Manager
if [[ ! -f "${vim_plug_dir}/plug.vim" ]]; then
  wget --directory-prefix=${vim_plug_dir} https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Clang Format
if [[ ! -f "${vim_dir}/clang-format.py" ]]; then
  wget --directory-prefix=${vim_dir} https://raw.githubusercontent.com/llvm/llvm-project/main/clang/tools/clang-format/clang-format.py
fi

# ------------------------------------------------------------------------------
# NVim
# ------------------------------------------------------------------------------
cp --force ${installer_dir}/os_vimrc ~/.vimrc
cp --force ${installer_dir}/os_clang_format_style_file ~/_clang-format
cp --force ${installer_dir}/os_nvim_init.vim ~/.config/nvim/init.vim

# ----------------------------------------------------------------------------
# Neovide
# ----------------------------------------------------------------------------
neovide_sha256=dbd0903bae5baff550406fd1e09e7ca0afc57ec855305545ae1c13485c7f1d69
neovide_exe_sha256=fc946c3d58f6e61eef78635eec81cbbb067b02c0deffb7661254896ce5b20578
neovide_version=0.8.0

neovide_download_file=${downloads_dir}/neovide-v${neovide_version}.tar.gz.zip
neovide_dir=${tools_dir}/neovide-v${neovide_version}-linux
neovide_exe=${neovide_dir}/neovide

neovide_url=https://github.com/neovide/neovide/releases/download/${neovide_version}/neovide-linux.tar.gz.zip

if [[ ! -f "${neovide_exe}" ]]; then
    DownloadFile "https://github.com/neovide/neovide/releases/download/${neovide_version}/neovide-linux.tar.gz.zip" ${neovide_download_file}
    FileSHA256HashCheck ${neovide_download_file} ${neovide_sha256}

    unzip -o ${neovide_download_file} -d ${neovide_dir}
    tar xf ${neovide_dir}/neovide.tar.gz --overwrite --directory=${neovide_dir}
    mv ${neovide_dir}/target/release/neovide ${neovide_dir}
    rm -rf ${neovide_dir}/neovide.tar.gz
    rm -rf ${neovide_dir}/target
fi

FileSHA256HashCheck ${neovide_exe} ${neovide_exe_sha256}

# ------------------------------------------------------------------------------
# Ctags
# ------------------------------------------------------------------------------
rm --force ${bin_dir}/ctags_cpp.sh
echo ctags --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ \$\@ >> ${bin_dir}/ctags_cpp.sh
chmod +x ${bin_dir}/ctags_cpp.sh

