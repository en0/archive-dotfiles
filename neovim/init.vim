for f in split(glob('~/.config/nvim/config/*.vim'), '\n')
	exec 'source' f
endfor
