call plug#begin('~/.vim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

if has('nvim') || has('patch-8.0.902')
    Plug 'mhinz/vim-signify'
else
    Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

Plug 'Yggdroot/indentLine'
Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'ryanoasis/vim-devicons'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

filetype plugin indent on
syntax on

set fileencodings=ucs-bom,utf-8,cp1252,default,latin9
set nowrap
set number
set signcolumn=yes
set relativenumber
set list
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set updatetime=50
set termguicolors
set background=dark

let mapleader = ","

let g:indentLine_char = '¦'
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_leadingSpaceChar = '·'

" let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :Rg<CR>

let g:gruvbox_contrast_dark='hard'
let g:gruvbox_italic=1
colorscheme gruvbox

nmap <silent><leader>n :NERDTreeToggle<CR>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent>gd <Plug>(coc-definition)
nmap <leader>rn <Plug>(coc-rename)

" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac <Plug>(coc-codeaction)
" Apply AutoFix to problem on the currint line.
nmap <leader>qf <Plug>(coc-fix-current)
