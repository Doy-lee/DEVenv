" Plugins
" ==============================================================================
call plug#begin(stdpath('config') . '/plugged')
    " nerdtree provides a file tree explorer
    " vim-dispatch allows running async jobs in vim (i.e. builds in the background)
    Plug 'https://github.com/scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'https://github.com/tpope/vim-dispatch'
    Plug 'https://github.com/nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " Fast fuzzy searcher, the .vim repository pulls in sane defaults for
    " setting up fzf in vim.
    Plug 'https://github.com/junegunn/fzf'
    Plug 'https://github.com/junegunn/fzf.vim'

    " nvim-lspconfig sets up sane defaults for LSP servers (i.e. clangd)
    " nvim-cmp is a more powerful autocomplete engine
    " LuaSnip allow writing snippets into the buffer, we can power the snippets from LSP
    " cmp-nvim-lsp preset capability flags to request more powerful autocomplete from LSP server
    " cmp_luasnip a LuaSnip addon that provides a completion source to nvim-cmp
    " cmp-buffer provides a buffer completion source to nvim-cmp
    " cmp-path provides a path completion source to nvim-cmp
    Plug 'https://github.com/neovim/nvim-lspconfig'
    Plug 'https://github.com/hrsh7th/nvim-cmp'
    Plug 'https://github.com/L3MON4D3/LuaSnip'
    Plug 'https://github.com/hrsh7th/cmp-nvim-lsp'
    Plug 'https://github.com/saadparwaiz1/cmp_luasnip'
    Plug 'https://github.com/hrsh7th/cmp-buffer'
    Plug 'https://github.com/hrsh7th/cmp-path'

    " odin for syntax highlighting
    Plug 'https://github.com/Tetralux/odin.vim'
    Plug 'https://github.com/sainnhe/gruvbox-material'
call plug#end()

" Lua Setup
" ==============================================================================
lua <<EOF
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

  -- LSP Setup
  -- ===========================================================================
  -- Load the additional capabilities supported by nvim-cmp
  local custom_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local custom_on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap=true, silent=true }
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<A-n>',    vim.diagnostic.goto_next,  opts)
    vim.keymap.set('n', '<A-p>',    vim.diagnostic.goto_prev,  opts)

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n',  'K',    vim.lsp.buf.hover,           bufopts)
    vim.keymap.set('n', 'gD',    vim.lsp.buf.declaration,     bufopts)
    vim.keymap.set('n', 'gd',    vim.lsp.buf.definition,      bufopts)
    vim.keymap.set('n', 'gt',    vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'gr',    vim.lsp.buf.references,      bufopts)
    vim.keymap.set('n', 'gs',    vim.lsp.buf.signature_help,  bufopts)
    vim.keymap.set('n', '<A-a>', vim.lsp.buf.code_action,     bufopts)
    vim.keymap.set('n', '<A-r>', vim.lsp.buf.rename,          bufopts)
  end

  -- Request additional completion capabilities from the LSP server(s)
  local lspconfig = require('lspconfig')
  local servers   = { 'clangd', }
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup { on_attach = custom_on_attach, capabilities = custom_capabilities, }
  end

  -- Autocomplete Setup
  -- ===========================================================================
  local luasnip = require 'luasnip'
  local cmp     = require 'cmp'

  cmp.setup {
    snippet = {
      expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-l>'] = cmp.mapping.scroll_docs(-1),   -- Scroll the docs up   by 1 line
      ['<C-h>'] = cmp.mapping.scroll_docs(1),    -- Scroll the docs down by 1 line
      ['<CR>']  = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true, },
      ['<C-j>'] = cmp.mapping(function(fallback) -- Move down the autocomplete list
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<C-k>'] = cmp.mapping(function(fallback) -- Move up the autocomplete list
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = {
      { name = 'nvim_lsp' }, { name = 'luasnip' },
    },
  }

  -- Clangd LSP Setup
  -- ===========================================================================
  lspconfig.clangd.setup {
    single_file_support = false, --- Don't launch LSP if the directory does not have LSP metadata
  }

  require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "cpp" }, -- A list of parser names, or "all"
    sync_install     = false,          -- Install parsers synchronously (only applied to `ensure_installed`)
    ignore_install   = { },            -- List of parsers to ignore installing (for "all")

    highlight = {
      enable = true, -- `false` will disable the whole extension

      -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
      -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
      -- the name of the parser)
      -- list of language that will be disabled
      disable = { },

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }
EOF

" Theme
" ==============================================================================
let g:gruvbox_material_background='hard'
let g:gruvbox_material_foreground='mix'
let g:gruvbox_material_disable_italic_comment=1
let g:gruvbox_material_enable_italic=0
let g:gruvbox_material_enable_bold=0
let g:gruvbox_material_diagnostic_virtual_text='colored'
colorscheme gruvbox-material

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
nnoremap <leader>f :FzfFiles<CR>
nnoremap <leader>F :FzfFiles 
nnoremap <leader>t :FzfTags<CR>
nnoremap <leader>r :FzfRg<R>
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
