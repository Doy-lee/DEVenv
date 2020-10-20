if [[ ! -f "${HOME}/.vim/autoload/plug.vim" ]]; then
  wget --directory-prefix=../.vim/autoload https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [[ ! -f "${HOME}/.vim/clang-format.py" ]]; then
  wget --directory-prefix=${HOME}/.vim https://raw.githubusercontent.com/llvm-mirror/clang/master/tools/clang-format/clang-format.py
fi

cp -f Installer/_vimrc ~/.vimrc
cp -f Installer/unix_nvim_init.vim ~/.config/nvim/init.vim

sudo apt install exuberant-ctags neovim clang-format ripgrep

cat > ~/.tmux.conf <<EOF
set-option -g mouse on
set-option escape-time 0
set -g prefix2 C-a #Set prefix to also Ctrl+A

# make scrolling with wheels work
bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
bind -n WheelDownPane select-pane -t= \; send-keys -M

bind v split-window -v
bind s split-window -h
bind r source-file ~/.tmux.conf # Bind reload to R

# switch panes using <prefix> (hjkl) vim style keys
bind h select-pane -L
bind l select-pane -R
bind j select-pane -U
bind k select-pane -D

bind -n M-Left resize-pane -L 10
bind -n M-Right resize-pane -R 10
bind -n M-Up resize-pane -U 10
bind -n M-Down resize-pane -D 10
EOF

mkdir -p Bin
rm -rf Bin/ctags_cpp.sh
echo ctags --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ $@ >> Bin/ctags_cpp.sh
