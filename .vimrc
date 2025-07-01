" Don't try to be vi compatible
set nocompatible

let &t_SI = "\e[6 q" " Bar in insert mode
let &t_EI = "\e[2 q" " Block in other modes

" Helps force plugins to load correctly when it is turned back on below
filetype off

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on

packloadall

call LspAddServer([#{
  \    name: "zls",
  \    filetype: ["zig", "zon"],
  \    path: "zls",
  \    args: []
  \  }])

call LspAddServer([#{
  \    name: "clangd",
  \    filetype: ["c", "cpp"],
  \    path: "clangd",
  \    args: [
    \       "--background-index", 
    \       "--clang-tidy", 
    \       "--compile-commands-dir=./zig-out/cdb"]
  \  }])

call LspAddServer([#{
  \    name: 'golang',
  \    filetype: ['go', 'gomod'],
  \    path: 'gopls',
  \    args: ['serve'],
  \    syncInit: v:true
  \  }])

call LspAddServer([#{name: 'omnisharp',
     \   filetype: 'cs',
     \   path: "OmniSharp",
     \   args: ['-z', '--languageserver', '--encoding', 'utf-8'],
     \ }])

call LspAddServer([#{name: 'nil',
     \   filetype: 'nix',
     \   path: "nil",
     \   args: [],
     \ }])

call LspAddServer([#{name: "pylsp",
    \   filetype: "python",
    \   path: "pylsp",
  \    args: []
    \ }])

call LspAddServer([#{
  \    name: 'typescriptlang',
  \    filetype: ['javascript', 'typescript'],
  \    path: 'typescript-language-server',
  \    args: ['--stdio'],
  \  }])

call LspAddServer([#{
  \    name: 'rustlang',
  \    filetype: ['rust'],
  \    path: 'rust-analyzer',
  \    args: [],
  \    syncInit: v:true
  \  }])

call LspOptionsSet(#{
    \    showDiagWithSign: v:false,
    \    showDiagWithVirtualText: v:true,
    \    completionMatcher: "fuzzy",
    \  })

au BufWrite * :silent LspFormat

" TODO: Pick a leader key
let mapleader = " "

" LSP keybinds
nnoremap <silent> gd :LspGotoDefinition<CR>
nnoremap <silent> <S-k> :LspHover<CR>
nnoremap <silent> <C-.> :LspCodeAction<CR>
nnoremap <silent> <F2> :LspRename<CR>


" Tab autocomplete
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

" Fuzzy finding
nnoremap <silent> <leader>f :CtrlP<CR>

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround

if &filetype ==# 'nix' || &filetype ==# 'vue'
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
endif

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk
" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
" map <esc> :let @/=''<cr> " clear search
"
set noswapfile

" Splits
set splitright
nnoremap <A-TAB> <C-w><C-w>


" Remove selection highlights.
nnoremap <TAB> :noh<CR>

" Cliboard copy
vnoremap <silent> <leader>y y:call system('wl-copy', getreg('"'))<CR>
nnoremap <silent> <leader>y :.w !wl-copy<CR><CR>

" Buffer switching
nnoremap <silent> <A-.> :bnext<CR>
nnoremap <silent> <A-,> :bprev<CR>
nnoremap <leader>b :ls<cr>:b<space>

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬

" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

" Color scheme (terminal)
set termguicolors
set background=dark
autocmd vimenter * ++nested colorscheme gruvbox

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50

" set t_Co=256
" let g:solarized_termcolors=256
" let g:solarized_termtrans=1
" put https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
" in ~/.vim/colors/ and uncomment:
" colorscheme solarized

