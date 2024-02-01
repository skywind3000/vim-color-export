# vim-color-export

Export current colorscheme in traditional Vim color format:

1) Can export NeoVim dedicated colors to Vim.
2) Can export GUI colors to terminal 256 colors format.


## Install

vim-plug:

```VimL
Plug 'skywind3000/vim-color-export'
```

## Usage

Export current colorscheme to "tokyonight.vim" :

```VimL
:ColorExport ~/.vim/colors/tokyonight.vim'
```

and you can use 'tokyonight' in Vim.

## Options

#### g:color_export_all

Default to 0, set to 1 to export all highlight groups.

#### g:color_export_extra

Default to an empty list, a list of extra highlight groups to export (when g:color_export_all is `0`):

```VimL
let g:color_export_extra = ['GitGutterAdd', 'GitGutterChange', 'GitGutterDelete', 'GitGutterChangeDelete']
```

#### g:color_export_convert

Convert gui colors to cterm colors, make current colorscheme usable in any 256-colors terminal without `:set termguicolors`.




