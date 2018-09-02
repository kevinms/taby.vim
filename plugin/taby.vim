"File: tabnum.vim
"Maintainer: Kevin Smith
"Description: Display tab numbers in the tab line

" Faster way to go to tab page by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

set tabline=%!MyTabLine()
function MyTabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		" select the highlighting
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
		else
			"let s .= '%#TabLine#'
			let s .= '%#TabLineFill#'
		endif

		" the label is made by MyTabLabel()
		let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
	endfor

	" after the last tab fill with TabLineFill and reset tab page nr
	let s .= '%#TabLineFill#%T'

	return s
endfunction

function MyTabLabel(n)
	" tab number
	let s = a:n . ' '

	" count modified buffers
	let modified = 0
	for b in tabpagebuflist(a:n)
		if getbufvar( b, "&modified" )
			let modified += 1
		endif
	endfor
	if modified > 0
		"let s .= '[' . modified . '+]'
	endif

	" current buffer in current tab
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let b = buflist[winnr - 1]

	" simplified buffer name
	" Based on: http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
	if getbufvar( b, "&buftype" ) == 'help'
		let s .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
	elseif getbufvar( b, "&buftype" ) == 'quickfix'
		let s .= '[Q]'
	else
		let s .= bufname(b) == '' ? '[New]' : pathshorten(bufname(b))
	endif

	return s
endfunction
