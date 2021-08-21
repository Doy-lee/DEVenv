vim_dir=${HOME}/.vim
vim_plug_dir=${vim_dir}/autoload
mkdir --parents ${vim_plug_dir}

if [[ ! -f "${vim_plug_dir}/plug.vim" ]]; then
  wget --directory-prefix=${vim_plug_dir} https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [[ ! -f "${vim_dir}/clang-format.py" ]]; then
  wget --directory-prefix=${vim_dir} https://raw.githubusercontent.com/llvm/llvm-project/main/clang/tools/clang-format/clang-format.py
fi

#
# Dependencies
#
sudo apt install exuberant-ctags neovim clang-format ripgrep

#
# NVim
#
mkdir --parents ~/.config/nvim

cp --force Installer/_vimrc ~/.vimrc
cp --force Installer/unix_nvim_init.vim ~/.config/nvim/init.vim
cp --force Installer/clang-format-style-file ~/_clang-format

#
# Ctags
#
mkdir --parents Bin
rm --force Bin/ctags_cpp.sh
echo ctags --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ \$\@ >> Bin/ctags_cpp.sh
chmod +x Bin/ctags_cpp.sh
