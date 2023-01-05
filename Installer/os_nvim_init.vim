" Plugins
" ==============================================================================
call plug#begin(stdpath('config') . '/plugged')
    " nerdtree provides a file tree explorer
    " vim-dispatch allows running async jobs in vim (i.e. builds in the background)
    Plug 'https://github.com/scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'https://github.com/tpope/vim-dispatch'
    Plug 'https://github.com/tpope/vim-fugitive'
    Plug 'https://github.com/tpope/vim-abolish'

    " TODO: 2022-06-19 Treesitter is too slow on large C++ files
    " Plug 'https://github.com/nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'https://github.com/bfrg/vim-cpp-modern'

    " FZF
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    " odin for syntax highlighting
    Plug 'https://github.com/Tetralux/odin.vim'
    Plug 'https://github.com/sainnhe/gruvbox-material'

    " Lua cache to speed up load times
    Plug 'https://github.com/lewis6991/impatient.nvim'

    " lsp-zero begin
        " LSP Support
        Plug 'neovim/nvim-lspconfig'
        Plug 'williamboman/mason.nvim'
        Plug 'williamboman/mason-lspconfig.nvim'

        " Autocompletion
        Plug 'hrsh7th/nvim-cmp'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'hrsh7th/cmp-path'
        Plug 'saadparwaiz1/cmp_luasnip'
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'hrsh7th/cmp-nvim-lua'

        "  Snippets
        Plug 'L3MON4D3/LuaSnip'

        " Snippet collection (Optional)
        Plug 'rafamadriz/friendly-snippets'
        Plug 'VonHeikemen/lsp-zero.nvim'
    " lsp-zero end
call plug#end()

" Lua Setup
" ==============================================================================
lua <<EOF
  require('impatient')

  -- LSP Setup
  -- ===========================================================================
  local lsp = require('lsp-zero')
  lsp.preset('recommended')
  lsp.setup()

  -- Treesitter
  -- ===========================================================================
  -- TODO: 2022-06-19 Treesitter is too slow on large C++ files
  -- require('nvim-treesitter.configs').setup {
  --   ensure_installed = { "c", "cpp" }, -- A list of parser names, or "all"
  --   sync_install     = false,          -- Install parsers synchronously (only applied to `ensure_installed`)
  --   ignore_install   = { },            -- List of parsers to ignore installing (for "all")

  --   highlight = {
  --     enable = false, -- `false` will disable the whole extension

  --     -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
  --     -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
  --     -- the name of the parser)
  --     -- list of language that will be disabled
  --     disable = { },

  --     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
  --     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
  --     -- Using this option may slow down your editor, and you may see some duplicate highlights.
  --     -- Instead of true it can also be a list of languages
  --     additional_vim_regex_highlighting = false,
  --   },
  -- }

  -- Vim Options
  -- ===========================================================================
  vim.opt.autowrite=true        -- Automatically save before cmds like :next and :prev
  vim.opt.colorcolumn={80, 100} -- Set a 80 and 100 char column ruler
  vim.opt.completeopt={'menu', 'menuone', 'noselect'}
  vim.opt.cpoptions:append('$') -- $ as end marker for the change operator
  vim.opt.cursorline=true       -- Highlight current line
  vim.opt.expandtab=true        -- Replace tabs with spaces
  vim.opt.guifont={'JetBrains_Mono:h9',
                   'Consolas:h9',
                   'InputMonoCondensed:h9'}
  vim.opt.hlsearch=false        -- Highlight just the first match on search
  vim.opt.ignorecase=true       -- Search is not case sensitive
  vim.opt.linebreak=true        -- On wrapped lines, break on the wrapping word intelligently
  vim.opt.list=true             -- Show the 'listchar' characters on trailing spaces, tabs e.t.c
  vim.opt.listchars:append('tab:>-,trail:■,extends:»,precedes:«')
  vim.opt.number=true           -- Show line numbers
  vim.opt.relativenumber=true   -- Show relative line numbers
  vim.opt.shiftwidth=4          -- Number of spaces for each autoindent step
  vim.opt.splitright=true       -- Open new splits to the right of the current one
  vim.opt.swapfile=false        -- Disable swapfile (stores the things changed in a file)
  vim.opt.textwidth=80          -- On format, format to 80 char long lines
  vim.opt.visualbell=true       -- Flash the screen on error
  vim.opt.wrap=false            -- Don't wrap lines of text automatically
  vim.opt.signcolumn = 'no'

  vim.diagnostic.config({
    -- Turn off the diagnostics signs on the line number. In LSP mode, editing
    -- a C++ buffer constantly toggles the sign column on and off as you change
    -- modes which is very visually distracting.
    signs = false,
  })

  -- Check if there were args (i.e. opened file), non-empty buffer, or started in insert mode
  if vim.fn.argc() == 0 or vim.fn.line2byte("$") ~= -1 and not opt.insertmode then
    local ascii = {
        "",
        "  Useful Bindings (Normal Mode)",
        "  --------------------------------------------------",
        "  <Ctrl+n>    to open the file tree explorer",
        "  <Ctrl+i>    clang format selected lines",
        "  <Ctrl+j>    jump to next compilation error",
        "  <Ctrl+k>    jump to prev compilation error",
        "  <cd>        change working directory to current file",
        "  <\\s>       split buffer vertically",
        "",
        "  Abolish (Text Substitution in Normal Mode)",
        "  --------------------------------------------------",
        "  %S/facilit{y,ies}/building{,s}/g Convert facility->building, facilities->buildings",
        "  %S/action/sleep/g                Convert action to sleep, (preserve case sensitivity ACTION->SLEEP, action->sleep) ",
        "",
        "  FZF (Normal Mode)",
        "  --------------------------------------------------",
        "  <\\h>       vim command history",
        "  <\\f>       find files",
        "  <\\g>       search for text (via ripgrep)",
        "  <\\tt>      search for tag (global)",
        "  <\\tb>      search for tag (buffer)",
        "  <\\cc>      search for commit (global)",
        "  <\\cb>      search for commit (buffer)",
        "  <\\b>       search for buffer",
        "",
        "  Autocompletion (nvim-cmp in Normal Mode)",
        "  --------------------------------------------------",
        "  <Enter>     Confirms selection.",
        "  <Ctrl-y>    Confirms selection.",
        "  <Up>        Navigate to previous item on the list.",
        "  <Down>      Navigate to the next item on the list.",
        "  <Ctrl-p>    Navigate to previous item on the list.",
        "  <Ctrl-n>    Navigate to the next item on the list.",
        "  <Ctrl-u>    Scroll up in the item's documentation.",
        "  <Ctrl-f>    Scroll down in the item's documentation.",
        "  <Ctrl-e>    Toggles the completion.",
        "  <Ctrl-d>    Go to the next placeholder in the snippet.",
        "  <Ctrl-b>    Go to the previous placeholder in the snippet.",
        "  <Tab>       Enables completion when the cursor is inside a word. If the completion menu is visible it will navigate to the next item in the list.",
        "  <Shift-Tab> When the completion menu is visible navigate to the previous item in the list.",
        "",
        "  LSP Bindings (Normal Mode)",
        "  --------------------------------------------------",
        "  <Shift-K>   Displays hover information about the symbol under the cursor in a floating window. See help vim.lsp.buf.hover().",
        "  gd          Jumps to the definition of the symbol under the cursor. See help vim.lsp.buf.definition().",
        "  gD          Jumps to the declaration of the symbol under the cursor. Some servers don't implement this feature. See help vim.lsp.buf.declaration().",
        "  gi          Lists all the implementations for the symbol under the cursor in the quickfix window. See help vim.lsp.buf.implementation().",
        "  go          Jumps to the definition of the type of the symbol under the cursor. See help vim.lsp.buf.type_definition().",
        "  gr          Lists all the references to the symbol under the cursor in the quickfix window. See help vim.lsp.buf.references().",
        "  <Ctrl-k>    Displays signature information about the symbol under the cursor in a floating window. See help vim.lsp.buf.signature_help(). If a mapping already exists for this key this function is not bound.",
        "  <F2>        Renames all references to the symbol under the cursor. See help vim.lsp.buf.rename().",
        "  <F4>        Selects a code action available at the current cursor position. See help vim.lsp.buf.code_action().",
        "  gl          Show diagnostics in a floating window. See :help vim.diagnostic.open_float().",
        "  [d          Move to the previous diagnostic in the current buffer. See :help vim.diagnostic.goto_prev().",
        "  ]d          Move to the next diagnostic. See :help vim.diagnostic.goto_next()."
    }

    local height = vim.api.nvim_get_option("lines")
    local width = vim.api.nvim_get_option("columns")
    local ascii_rows = #ascii
    local ascii_cols = #ascii[1]
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(true, true)

    local function reset_start_screen()
        vim.cmd("enew")
        local buf = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_buf_set_option(buf, "modifiable", true)
        vim.api.nvim_buf_set_option(buf, "buflisted", true)
        vim.api.nvim_buf_set_option(buf, "buflisted", true)
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, ascii)
    vim.api.nvim_buf_set_option(buf, "modified", false)
    vim.api.nvim_buf_set_option(buf, "buflisted", false)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "swapfile", false)
    vim.api.nvim_set_current_buf(buf)

    vim.api.nvim_create_autocmd("InsertEnter,WinEnter", {
        pattern = "<buffer>",
        callback = reset_start_screen,
    })
  end

EOF

" Theme
" ==============================================================================
let g:gruvbox_material_background='hard'
let g:gruvbox_material_foreground='mix'
let g:gruvbox_material_disable_italic_comment=1
let g:gruvbox_material_enable_italic=0
let g:gruvbox_material_enable_bold=0
let g:gruvbox_material_diagnostic_virtual_text='colored'
let g:gruvbox_material_better_performance=1
colorscheme gruvbox-material

" Vim-cpp-modern customisation
" Disable function highlighting (affects both C and C++ files)
let g:cpp_function_highlight = 1

" Enable highlighting of C++11 attributes
let g:cpp_attributes_highlight = 1

" Highlight struct/class member variables (affects both C and C++ files)
let g:cpp_member_highlight = 0

" Put all standard C and C++ keywords under Vim's highlight group 'Statement'
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

" Options
" ==============================================================================
" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P

" Resize splits when the window is resized
au VimResized * :wincmd =

" File patterns to ignore in command line auto complete
set wildignore+=*.class,*.o
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.obj,*.vcxproj,*.pdb,*.idb

" Setup undo file
set undofile
let &undodir=stdpath('config') . '/undo'

" Setup backup directory
let &backupdir=stdpath('config') . '/backup'

" Enable mouse support
if has('mouse')
    set mouse=a
endif

" Functions
" ==============================================================================
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

" General Key Bindings
" ==============================================================================
" Telescope Bindings
nnoremap <leader>h   <cmd>FzfHistory<cr>
nnoremap <leader>f   <cmd>FzfFiles<cr>
nnoremap <leader>g   <cmd>FzfRg<cr>
nnoremap <leader>tt  <cmd>FzfTags<cr>
nnoremap <leader>tb  <cmd>FzfBTags<cr>
nnoremap <leader>cc  <cmd>FzfCommits<cr>
nnoremap <leader>cb  <cmd>FzfBCommits<cr>
nnoremap <leader>b  <cmd>FzfBuffers<cr>

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
nnoremap <A-j> :cn<CR>
nnoremap <A-k> :cp<CR>

" FZF
" ==============================================================================
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

" Vim Dispatch
" ==============================================================================
let s:running_windows = has("win16") || has("win32") || has("win64")
if s:running_windows
    set makeprg=build
    nnoremap <f5> :Make ./build.bat<cr>
else
    " Set vim terminal to enter normal mode using escape like normal vim behaviour
    tnoremap <Esc> <C-\><C-n>
    nnoremap <f5> :Make ./build.sh<cr>
    set makeprg=./build.sh
endif
