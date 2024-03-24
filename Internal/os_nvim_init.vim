" Plugins ==========================================================================================
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

    " FZF for LSP
    Plug 'gfanto/fzf-lsp.nvim'
    Plug 'nvim-lua/plenary.nvim'

    " odin for syntax highlighting
    Plug 'https://github.com/Tetralux/odin.vim'
    Plug 'https://github.com/sainnhe/gruvbox-material'
    Plug 'https://github.com/ggandor/leap.nvim'

    " lsp-zero begin
        " LSP Support
        Plug 'williamboman/mason.nvim'
        Plug 'williamboman/mason-lspconfig.nvim'
        Plug 'neovim/nvim-lspconfig'
        Plug 'hrsh7th/nvim-cmp'
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'L3MON4D3/LuaSnip'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'hrsh7th/cmp-path'
        Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v3.x'}
    " lsp-zero end
call plug#end()

" Lua Setup ========================================================================================
lua <<EOF
  local leap = require('leap')
  vim.keymap.set({'n', 'x', 'o'}, '<tab>', '<Plug>(leap-forward-to)')
  vim.keymap.set({'n', 'x', 'o'}, '<S-tab>', '<Plug>(leap-backward-to)')

  -- LSP Setup =====================================================================================
  local devenver_root = vim.fn.getenv('devenver_root')
  local lsp_zero = require('lsp-zero')
  lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
    local opts = {buffer = bufnr}

    vim.keymap.set({'n', 'x'}, 'gq', function()
      vim.lsp.buf.format({async = false, timeout_ms = 10000})
    end, opts)
  end)

  -- to learn how to use mason.nvim with lsp-zero
  -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
  require('mason').setup({})
  require('mason-lspconfig').setup({
    ensure_installed = { "clangd" },
    handlers = {
      lsp_zero.default_setup,
    },
  })

  local cmp = require('cmp')
  local cmp_action = require('lsp-zero').cmp_action()
  local cmp_format = require('lsp-zero').cmp_format({details = true})

  cmp.setup({
    sources = {
      {name = 'nvim_lsp'},
      {name = 'buffer'},
      {name = 'path'},

    },
    mapping = cmp.mapping.preset.insert({
      ['<Tab>'] = cmp_action.luasnip_supertab(),
      ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
      ['<CR>'] = cmp.mapping.confirm({select = false}),
    }),
    --- (Optional) Show source name in completion menu
    formatting = cmp_format,
  })

  -- Treesitter ====================================================================================
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

  -- Vim Options ===================================================================================
  vim.opt.autowrite=true        -- Automatically save before cmds like :next and :prev
  vim.opt.colorcolumn={80, 100} -- Set a 80 and 100 char column ruler
  vim.opt.completeopt={'menu', 'menuone', 'noselect'}
  vim.opt.cpoptions:append('$') -- $ as end marker for the change operator
  vim.opt.cursorline=true       -- Highlight current line
  vim.opt.expandtab=true        -- Replace tabs with spaces
  vim.opt.guifont='JetBrains_Mono:h9','Consolas:h9','InputMonoCondensed:h9'
  vim.opt.hlsearch=false        -- Highlight just the first match on search
  vim.opt.ignorecase=true       -- Search is not case sensitive
  vim.opt.linebreak=true        -- On wrapped lines, break on the wrapping word intelligently
  vim.opt.list=true             -- Show the 'listchar' characters on trailing spaces, tabs e.t.c ===
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

  -- Automatically scroll to bottom of quickfix window when opened
  vim.cmd([[
    autocmd FileType qf lua vim.cmd('normal! G')
  ]])
EOF

" Theme ============================================================================================
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

" Options ==========================================================================================
" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P

" File patterns to ignore in command line auto complete
set wildignore+=*.class,*.o,*\\tmp\\*,*.swp,*.zip,*.exe,*.obj,*.vcxproj,*.pdb,*.idb

" Setup undo file
set undofile
let &undodir=stdpath('config') . '/undo'

" Setup backup directory
let &backupdir=stdpath('config') . '/backup'

" Enable mouse support
if has('mouse')
    set mouse=a
endif

" Functions ========================================================================================
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

function! RemedyBGOpenFile()
    execute("!remedybg open-file " . expand("%:p") . " " . line("."))
    execute("!powershell -Command Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::AppActivate(' - RemedyBG')")
endfunction
command RemedyBGOpenFile call RemedyBGOpenFile()

function! RemedyBGStartDebugging()
    execute("!remedybg start-debugging " . expand("%:p") . " " . line("."))
endfunction
command RemedyBGStartDebugging call RemedyBGStartDebugging()

function! RemedyBGStopDebugging()
    execute("!remedybg stop-debugging " . expand("%:p") . " " . line("."))
endfunction
command RemedyBGStopDebugging call RemedyBGStopDebugging()

function! RemedyBGRunToCursor()
    execute("!remedybg open-file " . expand("%:p") . " " . line("."))
    execute("!remedybg run-to-cursor " . expand("%:p") . " " . line("."))
    execute("!powershell -Command Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::AppActivate(' - RemedyBG')")
endfunction
command RemedyBGRunToCursor call RemedyBGRunToCursor()

function! RemedyBGAddBreakpointAtFile()
    execute("!remedybg open-file " . expand("%:p") . " " . line("."))
    execute("!remedybg add-breakpoint-at-file " . expand("%:p") . " " . line("."))
    execute("!powershell -Command Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::AppActivate(' - RemedyBG')")
endfunction
command RemedyBGAddBreakpointAtFile call RemedyBGAddBreakpointAtFile()

nnoremap <silent> <F6>    <cmd>RemedyBGOpenFile<cr><cr>
nnoremap <silent> <F5>    <cmd>RemedyBGStartDebugging<cr><cr>
nnoremap <silent> <S-F5>  <cmd>RemedyBGStopDebugging<cr><cr>
nnoremap <silent> <F9>    <cmd>RemedyBGAddBreakpointAtFile<cr><cr>
nnoremap <silent> <C-F10> <cmd>RemedyBGRunToCursor<cr><cr>

" FZF ==============================================================================================
" Empty value to disable preview window altogether
let g:fzf_preview_window = []

" Prefix all commands with Fzf for discoverability
let g:fzf_command_prefix = 'Fzf'

" - down / up / left / right
let g:fzf_layout = { 'down': '40%' }

command! -nargs=* -bang FzfCustomRG call RipgrepFzf(<q-args>, <bang>0)

" Augment the "FzfCustomFiles" command
command! -bang -nargs=? -complete=dir FzfCustomFiles
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'cat {}']}, <bang>0)

" General Key Bindings =============================================================================
" FZF Bindings
nnoremap <leader>h  <cmd>FzfHistory<cr>
nnoremap <leader>f  <cmd>FzfCustomFiles<cr>
nnoremap <leader>g  <cmd>FzfRg<cr>
nnoremap <leader>t  :FzfWorkspaceSymbols<space>
nnoremap <leader>cc <cmd>FzfCommits<cr>
nnoremap <leader>cb <cmd>FzfBCommits<cr>
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

" Vim Dispatch =====================================================================================
let s:running_windows = has("win16") || has("win32") || has("win64")
if s:running_windows
    set makeprg=build.bat
else
    " Set vim terminal to enter normal mode using escape like normal vim behaviour
    tnoremap <Esc> <C-\><C-n>
    set makeprg=./build.sh
endif
nnoremap <C-b> :Make<cr>
