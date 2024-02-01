"======================================================================
"
" colors.vim - 
"
" Created by skywind on 2024/02/01
" Last Modified: 2024/02/01 22:48
"
"======================================================================

"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
let s:default_fg = 'NONE'
let s:default_bg = 'NONE'


"----------------------------------------------------------------------
" gui_to_term
"----------------------------------------------------------------------
function! s:gui_to_cterm(color) abort
	let cc = a:color
	if cc == ''
		return 'NONE'
	elseif cc == 'NONE'
		return 'NONE'
	elseif cc == 'fg'
		return s:default_fg
	elseif cc == 'bg'
		return s:default_bg
	endif
	return colorexp#palette#name2index(cc)
endfunc


"----------------------------------------------------------------------
" dump style
"----------------------------------------------------------------------
function! colorexp#colors#dump_style(hid, mode)
	let hid = (type(a:hid) == 0)? (a:hid) : hlID(a:hid)
	let t = ['underline', 'undercurl', 'reverse', 'inverse']
	let t += ['italic', 'bold', 'standout']
	call filter(t, 'synIDattr(hid, v:val, a:mode)')
	let r = empty(t)? 'NONE' : join(t, ',')
	return r
endfunc


"----------------------------------------------------------------------
" dump highlight group
"----------------------------------------------------------------------
function! colorexp#colors#dump_highlight(hid, gui2term) abort
	let hid = (type(a:hid) == 0)? (a:hid) : hlID(a:hid)
	let name = synIDattr(hid, 'name')
	if !hlexists(name) 
		return ''
	endif
	let link = synIDtrans(hid)
	if hid != link
		let linkname = synIDattr(link, 'name')
		return printf("hi link %s %s", name, linkname)
	endif
	let part = []
	let gui = colorexp#colors#dump_style(hid, 'gui')
	let term = colorexp#colors#dump_style(hid, 'term')
	let cterm = colorexp#colors#dump_style(hid, 'cterm')
	if cterm == '' || a:gui2term
		let cterm = gui
	endif
	if gui != ''
		let part += ['gui=' .. gui]
	endif
	if term != ''
		let part += ['term=' .. term]
	endif
	if cterm != ''
		let part += ['cterm=' .. cterm]
	endif
	let guifg = synIDattr(hid, 'fg#', 'gui')
	let guibg = synIDattr(hid, 'bg#', 'gui')
	let guisp = synIDattr(hid, 'sp#', 'gui')
	let ctermfg = synIDattr(hid, 'fg', 'cterm')
	let ctermbg = synIDattr(hid, 'bg', 'cterm')
	if a:gui2term
		let ctermfg = ''
		let ctermbg = ''
	endif
	if ctermfg == ''
		let ctermfg = s:gui_to_cterm(guifg)
	endif
	if ctermbg == ''
		let ctermbg = s:gui_to_cterm(guibg)
	endif
	let guifg = (guifg == '')? 'NONE' : guifg
	let guibg = (guibg == '')? 'NONE' : guibg
	let fmt = 'guifg=%s guibg=%s ctermfg=%s ctermbg=%s'
	let part += [printf(fmt, guifg, guibg, ctermfg, ctermbg)]
	if guisp != ''
		let part += ['guisp=' .. guisp]
	endif
	if gui == 'NONE' && term == 'NONE' && cterm == 'NONE'
		if guifg == 'NONE' && guibg == 'NONE' && ctermfg == 'NONE'
			if ctermbg == 'NONE' && guisp == ''
				return printf('hi clear %s', name)
			endif
		endif
	endif
	return printf('hi %s %s', name, join(part, ' '))
endfunc


"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
function! colorexp#colors#update_normal()
	if hlexists('Normal')
		let xid = hlID('Normal')
		let bg = synIDattr(xid, 'bg#', 'gui')
		let fg = synIDattr(xid, 'fg#', 'gui')
		let s:default_fg = colorexp#palette#name2index(fg)
		let s:default_bg = colorexp#palette#name2index(bg)
	endif
endfunc


"----------------------------------------------------------------------
" convert to term
"----------------------------------------------------------------------
function! colorexp#colors#list_highlight(gui2term)
	let hid = 1
	let output = []
	let s:default_bg = 'NONE'
	let s:default_fg = 'NONE'
	call colorexp#colors#update_normal()
	while 1
		let hln = synIDattr(hid, 'name')
		if !hlexists(hln) 
			break
		endif
		let t = colorexp#colors#dump_highlight(hid, a:gui2term)
		let output += [t]
		let hid += 1
	endwhile
	return output
endfunc



"----------------------------------------------------------------------
" convert_gui_color
"----------------------------------------------------------------------
function! colorexp#colors#convert_gui_color()
	let script = colorexp#colors#list_highlight(1)
	exec 'hi clear'
	for n in script
		exec n
	endfor
endfunc



