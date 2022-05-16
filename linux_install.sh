vim_dir=${HOME}/.vim
vim_plug_dir=${vim_dir}/autoload

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
tools_dir=${script_dir}/Tools
bin_dir=${tools_dir}/binaries

mkdir --parents ${vim_plug_dir}
mkdir --parents ${bin_dir}
mkdir --parents ~/.config/nvim

if [[ ! -f "${vim_plug_dir}/plug.vim" ]]; then
  wget --directory-prefix=${vim_plug_dir} https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [[ ! -f "${vim_dir}/clang-format.py" ]]; then
  wget --directory-prefix=${vim_dir} https://raw.githubusercontent.com/llvm/llvm-project/main/clang/tools/clang-format/clang-format.py
fi

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------
sudo apt install exuberant-ctags neovim clang-format ripgrep

# ------------------------------------------------------------------------------
# NVim
# ------------------------------------------------------------------------------
cp --force ${script_dir}/Installer/os_vimrc ~/.vimrc
cp --force ${script_dir}/Installer/os_clang_format_style_file ~/_clang-format
cp --force ${script_dir}/Installer/unix_nvim_init.vim ~/.config/nvim/init.vim

# ------------------------------------------------------------------------------
# Ctags
# ------------------------------------------------------------------------------
rm --force ${bin_dir}/ctags_cpp.sh
echo ctags --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ \$\@ >> ${bin_dir}/ctags_cpp.sh
chmod +x ${bin_dir}/ctags_cpp.sh
