let s:menus = {}
let s:menus.qlts = { 'description': 'Quick List options for Typescript' }
let s:menus.qlts.command_candidates = [
    \ ['Find References', 'TSRef'],
    \ ['Goto Definition', 'TSDef'],
    \ ['Goto Type Definition', 'TSTypeDef'],
    \ ['Rename Symbol', 'TSRename'],
    \ ['Show Documentation', 'TSDoc'],
    \ ['Show Type', 'TSType'],
    \ ['Add Import', 'TSImport'],
    \ ]
call denite#custom#var('menu', 'menus', s:menus)
