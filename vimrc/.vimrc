" ~/.vimrc
"Personal Vim configuration
"January 2022

"note: if you need basic, vanilla configuration. look at bottom of file

"vim version 8.x and higher do not need plugin managers
"drop the plugins here to automaticaly load them on startup
"~/.vim/pack/plugin_folder_name/start/plugin_name
"plugins in opt folder can be loaded with :packadd packagename
"~/.vim/pack/plugin_folder_name/opt/plugin_name

"type :help [setting_name] to view detailed description
"type :help [plugin_name] to view plugin help file
"type :options to view compact list of all available options
"
set nocompatible                "disable compatibility with Vi, can cause issues
"==================================
"   Vim Plug
"==================================
"https://github.com/junegunn/vim-plug

call plug#begin()
"insert plugins between these two calls
"for GitHub repositories, you can just mention the username and repository
"otherwise you must add the full link after the Plug keyword
"run :PlugInstall to isntall new plugins
"run :PlugUpdate
"run :PlugStatus
"run :PlugClean to remove unlisted plugins

"left hand directory tree, run with <Ctrl-t>
Plug 'preservim/nerdtree'

"Fuzzy finder, fzf#install() makes sure that you have the latest binary, but it's optional
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

"Color scheme
Plug 'https://github.com/morhetz/gruvbox'
"Plug 'karoliskoncevicius/sacredforest-vim'
"Plug 'roosta/srcery'

" Use release branch (recommend)
" https://github.com/neoclide/coc.nvim
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Huge syntax and indentation support for multuple languages, more info at:
"https://github.com/sheerun/vim-polyglot
Plug 'https://github.com/sheerun/vim-polyglot'

"DevIcons, adds icons to different plugins
Plug 'https://github.com/ryanoasis/vim-devicons'

"VimWIki, super useful for personal note taking
Plug 'vimwiki/vimwiki'

"Lightline, simple statusline
Plug 'https://github.com/itchyny/lightline.vim'

call plug#end()
"<! --- end 


"==================================
"   General settings
"==================================
"type :options for all available options
syntax enable
filetype indent on
filetype plugin on              "enable plugin files


set clipboard=unnamedplus       "use system clipboard
set cursorline                  "highlight cursor line
set tabstop=4 softtabstop=4     "tab width of 4
set showtabline=2               "always show tabs
set shiftwidth=4                "press SHIFT + >> to shift line
set expandtab                   "use space characters instead of tabs
set cmdheight=2                 "increase space for command line
set number                      "line numbers
set relativenumber              "set rnu, relative line numbers
set mouse=a                     "enable mouse in all modes
set smartcase                   "search ignore case until i enter capital letter
set ignorecase                  "ignore case when search (enables smartcase)
set smartindent                 "smart indentation
set secure                      "prohibit .vimrc files to execute shell, create files ...
set wildmenu                    "pres <TAB> when typing command, use tab or shift+tab
set wildmode=longest:full,full  "wildmenu options, type :help wildmode
set hlsearch                    "highlight all search results
set incsearch                   "incremental search, show search before enter
set undodir=~/.vim/undodir      "undo directory
set undofile                    "persistent undofile, even after reboot
set nobackup                    "do not save backup files
set noswapfile                  "no swap files
set wrap                        "wrap long lines
set colorcolumn=80              "colored bar on column 80
set signcolumn=yes              "show column for event signs on left
set scrolloff=5                 "display 5 lines above/below when scrolling
set encoding=utf-8              "encoding utf-8
set t_Co=256                    "set 256 colors

let python_highlight_all=1      "enable all python syntax highlighting features
let mapleader=" "               "change the leader key from \ to <space>
"<! --- end


"==================================
"   Key remapping
"==================================
":help map-modes
"map (recursive mapping)
"noremap (non-recursive mapping)
"inoremap (insert-mode non-recursive mapping)
"nnoremap (normal-mode non-recursive mapping)
"<CR> carriage return (enter key)

"insert mode, non-recurseive, enter insert mode with jk
inoremap jk <ESC>
"buffer navigation
nnoremap <S-h> :bprevious<CR>
nnoremap <S-l> :bnext<CR>
"close buffer
nnoremap <S-q> :bd<CR>
"save buffer
nnoremap <S-Up> :w<CR>
"switch to left/right window
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
"toggle NerdTree
nnoremap <C-t> :NERDTreeToggle<CR>
"start FZF in current dir
nnoremap <leader>f :FZF<CR>
"start FZF in home dir
nnoremap <leader>F :FZF ~<CR>
"ale go to definition
nnoremap <leader>g :ALEGoToDefinition<CR>
"source %
nnoremap <leader>% :source %<CR>
"visual mode, easy indent
vnoremap < <gv
vnoremap > >gv
"<! --- end


"==================================
"   Color scheme 
"==================================
"Configurations

"gruvbox: https://github.com/morhetz/gruvbox/wiki/Configuration
colorscheme gruvbox
set background=dark

"srcery: https://vimawesome.com/plugin/srcery
"let g:srcery_bold=1             "enable bold text
"let g:srcery_italic=1           "enable italic text
"colorscheme srcery              "set colorscheme after config variables

"<! --- end


"==================================
"   Lightline settings (alternative to airline) 
"==================================
"simple status line, easy to configure
"https://github.com/itchyny/lightline.vim
"
set laststatus=2                "always show status line, on multiple windows
set noshowmode                  "hide default status

"advanced configuration
"https://github.com/itchyny/lightline.vim#advanced-configuration
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }


"<! --- end


"==================================
"   ALE Asynchronous Lint Engine
"==================================
" :ALEInfo to see config for current file type
" :help ale-content
" :help ale-options

"All this settings are defined in another file:
" vim automaticaly checks that folder
" ~/.vim/filetype/python.vim
"
" define code linters for python filetype
let g:ale_linters = {'python': ['flake8', 'pylint'],
                    \'markdown': ['markdownlint']} 

" define code formaters for python filetype
let g:ale_fixers = {'python': ['black']}

" only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1

" As-you-type autocomplete
set completeopt=menu,menuone,popup,preview,noselect,noinsert
let g:ale_completion_enabled = 1
"<! --- end


"==================================
"   VimWiki
"==================================
"change default directory, type :help vimwiki_list
"you can have different wikis with different options in list
"for better clarity consider defining varibles for every wiki: wiki1, wiki2...
let g:vimwiki_list = [{'path': '~/coding_documents/vimwiki/', 
                      \'path_html': '~/Documents/vimwiki_html/',
                     \'syntax': 'markdown', 'ext': '.md'}]
"
"vimwiki can use different styles of markup syntax
"remove upper comment to change default vimwiki syntax to markdown
".md can not convert to html at moment.

"<! --- end


"==================================
"   NERDTree
"==================================
"https://github.com/preservim/nerdtree

"<! --- end


"===================================
"   Vanilla Vim config
"===================================
"to run factory vim settings with plugins enabled
"copy these 2 lines and save them to essential.vim

"set nocompatible
"filetype plugin on

"when launching vim use this file instead of .vimrc
"   $ vim -u ~/essential.vim [filename]

"<! --- end

"===================================
"   COC settings
"===================================


