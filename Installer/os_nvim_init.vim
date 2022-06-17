" Plugins
" ==============================================================================
call plug#begin(stdpath('config') . '/plugged')
    Plug 'https://github.com/scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'https://github.com/junegunn/fzf'
    Plug 'https://github.com/junegunn/fzf.vim'
    Plug 'https://github.com/Tetralux/odin.vim'
    Plug 'https://github.com/morhetz/gruvbox'
call plug#end()

" Theme
" ==============================================================================
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_italic=0
let g:gruvbox_bold=0
colorscheme gruvbox

" Options
" ==============================================================================
set autowrite                 " Automatically save before commands like :next and :make
set nowrap                    " Don't wrap lines of text automatically
set ignorecase                " Search isn't case sensitive
set splitright                " Open new splits to the right of the current one
set visualbell                " Flash the screen on error
set expandtab                 " Replace tabs with spaces
set noswapfile                " Disable swapfile (stores the things changed in a file)
set colorcolumn=80,100        " Set a 80 and 100 char column ruler
set cpoptions+=$              " $ as end marker for the change operator
set cursorline                " Highlight current line
set linebreak                 " On wrapped lines, break on the wrapping word intelligently
set list                      " Show the 'listchar' characters on trailing spaces, tabs e.t.c
set listchars+=tab:>-,trail:■,extends:»,precedes:«
set number                    " Show line numbers
set relativenumber            " Show relative line numbers
set shiftwidth=4              " Number of spaces for each autoindent step
set textwidth=80              " On format, format to 80 char long lines
" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P
set guifont=JetBrains_Mono:h9,Consolas:h9,InputMonoCondensed:h9

" Resize splits when the window is resized
au VimResized * :wincmd =

" File patterns to ignore in command line auto complete
set wildignore+=*.class,*.o
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.obj,*.vcxproj,*.pdb,*.idb

" Setup undo file
set undofile
let &undodir=stdpath('config') . '/undo'

" Enable mouse support
if has('mouse')
    set mouse=a
endif

" Functions
" ==============================================================================
" Don't show trailing spaces in insert mode
augroup trailing
  au!
  au InsertEnter * :set listchars-=trail:■
  au InsertLeave * :set listchars+=trail:■
augroup END

" Increase font size using (Ctrl+Up Arrow) or (Ctrl+Down Arrow) if we are using
" gvim Otherwise font size is determined in terminal
nnoremap <C-Up> :silent! let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)+1)',
 \ 'g')<CR>
nnoremap <C-Down> :silent! let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)-1)',
 \ 'g')<CR>

" Formatting options (see :h fo-table)
augroup persistent_settings
  au!
  au bufenter * :set formatoptions=q1j
augroup end

" Return to the same line when a file is reopened
augroup line_return
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup end

" General Key Bindings
" ==============================================================================
" Map Ctrl+HJKL to navigate buffer window
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

" Move by wrapped lines instead of line numbers
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Map NERDTree to Ctrl-N
map <C-n> :NERDTreeToggle<CR>

" Change to current buffer's directory
nmap cd :cd <C-R>=expand("%:p:h")<CR><CR>

" Buffer Splitting
nnoremap <leader>s :vs<CR>

" Go to next error
" Go to previous error
nnoremap <A-n> :cn<CR>
nnoremap <A-p> :cp<CR>

" FZF
" ==============================================================================
nnoremap <leader>f :FzfFiles 
nnoremap <leader>t :FzfTags<CR>
nnoremap <leader>r :FzfRg 
nnoremap <leader>b :FzfBuffers<CR>
nnoremap <leader>l :FzfLines<CR>

" Empty value to disable preview window altogether
let g:fzf_preview_window = []

" Prefix all commands with Fzf for discoverability
let g:fzf_command_prefix = 'Fzf'

" - down / up / left / right
let g:fzf_layout = { 'down': '40%' }

" Clang Format
" ==============================================================================
map <C-I> :py3file ~/clang-format.py<CR>

" Compiler Error Formats
" ==============================================================================
" Error message formats thanks to
" https://forums.handmadehero.org/index.php/forum?view=topic&catid=4&id=704#3982
set errorformat+=\\\ %#%f(%l\\\,%c):\ %m                       " MSVC: MSBuild
set errorformat+=\\\ %#%f(%l)\ :\ %#%t%[A-z]%#\ %m             " MSVC: cl.exe
set errorformat+=\\\ %#%t%nxx:\ %m                             " MSVC: cl.exe, fatal errors is crudely implemented
set errorformat+=\\\ %#LINK\ :\ %m                             " MSVC: link.exe, can't find link library badly implemented
set errorformat+=\\\ %#%s\ :\ error\ %m                        " MSVC: link.exe, errors is badly implemented
set errorformat+=\\\ %#%s\ :\ fatal\ error\ %m                 " MSVC: link.exe, fatal errors is badly implemented
set errorformat+=\\\ %#%f(%l\\\,%c-%*[0-9]):\ %#%t%[A-z]%#\ %m " MSVC: HLSL fxc.exe
set errorformat+=%\\%%(CTIME%\\)%\\@=%m                        " ctime.exe -stats
