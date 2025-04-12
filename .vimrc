unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" basic settings
set mouse=c
set nu
set relativenumber 
set noic
set hlsearch
set noswapfile
set autoread
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set clipboard=unnamedplus

"splitting
set splitbelow
set splitright

set list

nnoremap J <C-o>
nnoremap K <C-i>

nnoremap H gT
nnoremap L gt

nnoremap <C-j> 10j
nnoremap <C-k> 10k

nnoremap ,<Space> :nohlsearch<CR>

" Для нормального режима
" nnoremap y "+y
" Для визуального режима
" vnoremap y "+y
