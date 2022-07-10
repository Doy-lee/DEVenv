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
    mkdir --parents "${cmake_dir}" && tar xf "${cmake_download_file}" --skip-old-files --directory="${cmake_dir}" || exit
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

fd_label=fd_linux64_${fd_version}
fd_download_label=fd-v${fd_version}-x86_64-unknown-linux-gnu
fd_download_file=${downloads_dir}/${fd_download_label}.tar.gz
fd_dir=${tools_dir}/${fd_label}
fd_exe=${fd_dir}/fd

if [[ ! -f "${fd_exe}" ]]; then
    DownloadFile "https://github.com/sharkdp/fd/releases/download/v${fd_version}/${fd_download_label}.tar.gz" "${fd_download_file}" || exit
    FileSHA256Check "${fd_download_file}" "${fd_sha256}" || exit
    mkdir --parents "${fd_dir}" && tar xf "${fd_download_file}" --skip-old-files --directory="${fd_dir}" || exit
    mv ${fd_dir}/${fd_download_label}/* "${fd_dir}" || exit
    rm --recursive ${fd_dir}/${fd_download_label} || exit
fi

FileSHA256Check "${fd_exe}" "${fd_exe_sha256}" || exit
ln --force --symbolic --relative "${fd_exe}" "${bin_dir}"

# LLVM/Clang
# ------------------------------------------------------------------------------
llvm_version_list=(11.1.0 12.0.1 13.0.1 14.0.0)

for llvm_version in ${llvm_version_list[@]}; do
    llvm_sha256=none
    llvm_exe_sha256=none
    if [[ "${llvm_version}" == "14.0.0" ]]; then
        llvm_sha256=61582215dafafb7b576ea30cc136be92c877ba1f1c31ddbbd372d6d65622fef5
        llvm_exe_sha256=3557c2deadae7e2bc3bffce4afd93ddab6ef50090971c8ce3bf15c80b27134a0
        llvm_download_label=clang+llvm-${llvm_version}-x86_64-linux-gnu-ubuntu-18.04
    elif [[ "${llvm_version}" == "13.0.1" ]]; then
        llvm_sha256=84a54c69781ad90615d1b0276a83ff87daaeded99fbc64457c350679df7b4ff0
        llvm_exe_sha256=ae47e6cc9f6d95f7a39e4800e511b7bdc3f55464ca79e45cd63cbd8a862a82a1
        llvm_download_label=clang+llvm-${llvm_version}-x86_64-linux-gnu-ubuntu-18.04
    elif [[ "${llvm_version}" == "12.0.1" ]]; then
        llvm_sha256=6b3cc55d3ef413be79785c4dc02828ab3bd6b887872b143e3091692fc6acefe7
        llvm_exe_sha256=329bba976c0cef38863129233a4b0939688eae971c7a606d41dd0e5a53d53455
	llvm_download_label=clang+llvm-${llvm_version}-x86_64-linux-gnu-ubuntu-16.04
    elif [[ "${llvm_version}" == "11.1.0" ]]; then
        llvm_sha256=c691a558967fb7709fb81e0ed80d1f775f4502810236aa968b4406526b43bee1
        llvm_exe_sha256=656bfde194276cee81dc8a7a08858313c5b5bdcfa18ac6cd6116297af2f65148
	llvm_download_label=clang+llvm-${llvm_version}-x86_64-linux-gnu-ubuntu-16.04
    fi

    llvm_download_file=${downloads_dir}/${llvm_download_label}.tar.xz
    llvm_label=llvm_linux64_${llvm_version}
    llvm_dir=${tools_dir}/${llvm_label}
    llvm_exe=${llvm_dir}/bin/clang
    
    if [[ ! -f "${llvm_exe}" ]]; then
        DownloadFile "https://github.com/llvm/llvm-project/releases/download/llvmorg-${llvm_version}/${llvm_download_label}.tar.xz" "${llvm_download_file}" || exit
        FileSHA256Check "${llvm_download_file}" "${llvm_sha256}" || exit
        mkdir --parents "${llvm_dir}" && tar xf "${llvm_download_file}" --skip-old-files --directory="${llvm_dir}" || exit

	if [[ "${llvm_version}" == "12.0.1" ]]; then
	    # NOTE: There was a distribution bug in v12.0.1 where the folder was misnamed
	    mv ${llvm_dir}/clang+llvm-${llvm_version}-x86_64-linux-gnu-ubuntu-/* ${llvm_dir} || exit
            rm --recursive ${llvm_dir}/clang+llvm-${llvm_version}-x86_64-linux-gnu-ubuntu || exit
	else
	    mv ${llvm_dir}/${llvm_download_label}/* ${llvm_dir} || exit
            rm --recursive ${llvm_dir}/${llvm_download_label} || exit
	fi
    fi
    
    FileSHA256Check "${llvm_exe}" "${llvm_exe_sha256}" || exit
    
    cd "${llvm_dir}/bin" && find . -type f,l -exec ln --force --symbolic --relative "{}" "${bin_dir}/{}-${llvm_version}" ';' && cd "${root_dir}"
done

cd "${llvm_dir}/bin" && find . -type f,l -exec ln --force --symbolic --relative "{}" "${bin_dir}/" ';' && cd "${root_dir}"

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
ln --force --symbolic --relative "${nvim_exe}" "${bin_dir}/nvim"
ln --force --symbolic --relative "${nvim_exe}" "${bin_dir}/vim"

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

    mkdir --parents "${cmake_dir}" && tar xf ${neovide_download_file} --skip-old-files --directory=${neovide_dir}/neovide-tmp || exit
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

python_label=python_linux64_${python_version}
python_download_label=cpython-${python_version}+20220630-x86_64-unknown-linux-gnu-install_only
python_download_file=${downloads_dir}/${python_download_label}.tar.gz
python_dir=${tools_dir}/${python_label}
python_exe=${python_dir}/bin/python3

if [[ ! -f "${python_exe}" ]]; then
    DownloadFile "https://github.com/indygreg/python-build-standalone/releases/download/20220630/${python_download_label}.tar.gz" "${python_download_file}" || exit
    FileSHA256Check "${python_download_file}" "${python_sha256}" || exit
    mkdir --parents "${python_dir}" && tar xf "${python_download_file}" --skip-old-files --directory="${python_dir}" || exit
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

ripgrep_label=ripgrep_linux64_${ripgrep_version}
ripgrep_download_label=ripgrep-${ripgrep_version}-x86_64-unknown-linux-musl
ripgrep_download_file=${downloads_dir}/${ripgrep_download_label}.tar.gz
ripgrep_dir=${tools_dir}/${ripgrep_label}
ripgrep_exe=${ripgrep_dir}/rg

if [[ ! -f "${ripgrep_exe}" ]]; then
    DownloadFile "https://github.com/BurntSushi/ripgrep/releases/download/${ripgrep_version}/${ripgrep_download_label}.tar.gz" "${ripgrep_download_file}" || exit
    FileSHA256Check "${ripgrep_download_file}" "${ripgrep_sha256}" || exit
    mkdir --parents "${ripgrep_dir}" && tar xf "${ripgrep_download_file}" --skip-old-files --directory="${ripgrep_dir}" || exit
    mv ${ripgrep_dir}/${ripgrep_download_label}/* "${ripgrep_dir}" || exit
    rm --recursive ${ripgrep_dir}/${ripgrep_download_label} || exit
fi

FileSHA256Check "${ripgrep_exe}" "${ripgrep_exe_sha256}" || exit
ln --force --symbolic --relative "${ripgrep_exe}" "${bin_dir}"

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


