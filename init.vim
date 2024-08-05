call plug#begin()

Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'folke/tokyonight.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'maxmellon/vim-jsx-pretty'
Plug 'dense-analysis/ale'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'numToStr/Comment.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-nerdtree-syntax-highlight'
Plug 'andymass/vim-matchup'
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'


call plug#end()

lua require('Comment').setup()

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['\\.git$', '\\.pyc$', '\\.o$', '\\.obj$', '\\.bak$', '\\.swp$', '\\.lock$']

" ALE configurations
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\		'typescriptreact': ['prettier', 'eslint']	,
\   'css': ['stylelint', 'prettier'],
\   'scss': ['stylelint', 'prettier'],
\}
let g:ale_linters = {
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'css': ['stylelint'],
\   'scss': ['stylelint'],
\}

let g:ale_linter_aliases = {'typescriptreact': 'typescript'}

nnoremap <C-t> :NERDTreeToggle<CR>

" Coc configs
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <leader>rn :call CocActionAsync('rename')<CR>


" Remap Esc to go from terminal insert mode to normal mode
" tnoremap <Esc> <C-\><C-n>

" map a key to show documentation when putting cursor at a method or variable
nnoremap <silent> K :call CocActionAsync('doHover')<CR>

" Map Enter to confirm selection in Coc.nvim
inoremap <expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"


" <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

nnoremap <leader>ff :lua require('telescope.builtin').find_files({ hidden = true })<CR>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>


lua << EOF
local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    -- Use ripgrep to exclude .git directory but include .gitignore files
    find_command = { 'rg', '--files', '--glob', '!.git/*' },
    file_ignore_patterns = { "node_modules", "package%-lock%.json", "README" },
  },
  pickers = {
    find_files = {
      -- Use ripgrep to exclude .git directory but include .gitignore files
      find_command = { 'rg', '--files', '--glob', '!.git/*' },
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<esc>"] = actions.close,
        },
      },
      hidden = true
    }
  }
}
EOF

" Load Comment.nvim and set up the plugin
lua << EOF
require('Comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}
EOF

lua << EOF
require('ts_context_commentstring').setup {
  enable_autocmd = false,
}
EOF

lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'javascript', 'typescript', 'tsx', 'html', 'vim', 'vimdoc'},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  matchup = {
    enable = true,
  }
}
EOF

" Setup toogleterm
lua << EOF
require("toggleterm").setup{
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = '1',
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = false,
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = true,
  shell = vim.o.shell,
}
EOF


autocmd VimEnter * NERDTree

set number
set tabstop=2
set shiftwidth=2
set expandtab
set nowrap
colorscheme tokyonight-night
