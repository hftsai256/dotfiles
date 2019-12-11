" --- Interface -----------------------------------------------
set background=dark
colorscheme hybrid
set termguicolors

" --- General Configuration -----------------------------------

syntax on
filetype off
filetype plugin indent on
set noswapfile               " just don't
set bs=indent,eol,start      " delete/backspace key fix
set cursorline               " highlight cursor line
set ci pi ts=4 sw=4 sts=4
set number
set showcmd
set autoindent
set wildmenu                 " visual autocomplete for cammand menu
set lazyredraw               " only redraw when necessay
set showmatch                " highlight matching [{()}]
set mouse=a                  " enable mouse scroll/click
set listchars=tab:▸\ ,eol:¬  " display hidden characters
set list                     " highlight unwanted spaces
let mapleader=","            " leader is comma

" --- Split Configuration -------------------------------------

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" --- Shortcuts -----------------------------------------------

ab #d #define
ab #i #include
ab <leader>b import pdb; pdb.set_trace()

" --- NETRW - NerdTree Replacement ----------------------------

let g:netrw_winsize = -28    " absolute width of netrw window
let g:netrw_banner = 0       " hide info on the top of window
let g:netrw_liststyle = 3    " tree-view

" sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*'

" use the previous window to open file
let g:netrw_browse_split = 4

" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <silent> <C-E> :call ToggleVExplorer()<CR>

" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
let g:netrw_browse_split = 4
let g:netrw_altv = 1

" Change directory to the current buffer when opening files.
set autochdir

" --- Searching -----------------------------------------------

set incsearch                " search as characters are entered
set hlsearch                 " highlight matches

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" --- Folding -------------------------------------------------

set foldenable               " enable folding
set foldlevelstart=10        " open most folds by default
set foldnestmax=10           " 10 nested fold max
set foldmethod=indent        " fold based on indent level
nnoremap <space> za          " space open/closes folds

" --- VIM-plug Setting ----------------------------------------

function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

call plug#begin('~/.config/nvim/plugins')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'Shougo/deoplete-clangx'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'sirtaj/vim-openscad'
call plug#end()

" --- Deoplete Auto-completion Engine Configuration -----------
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

" --- Ctrl-P Configuration ------------------------------------

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

" Turn off preview window after auto-completion is done
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>

function! s:my_cr_function() abort
  return deoplete#close_popup() . "\<CR>"
endfunction

" --- Airline Configuration ------------------------------------

let g:airline_powerline_fonts = 1
let g:airline_theme = 'bubblegum'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#checks = [ 'indent', 'long', 'mixed-indent-file' ]
