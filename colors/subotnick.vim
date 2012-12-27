" Vim color file
" Maintainer: Paul Severance <paulseverance+vim@gmail.com>
" Last Change: 2012-12-25
"
" This color file is a modification of the "summerfruit" color scheme by Armin Ronacher
" so that it can be used on 88- and 256-color xterms. The colors are translated
" using Henry So's programmatic approximation of gui colors from his "desert256"
" color scheme.
"
" I removed the "italic" option and the background color from
" comment-coloring because that looks odd on my console.
"
" The original "summerfruit" color scheme and "desert256" are available from vim.org.

set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="subotnick"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
    " functions {{{
    " returns an approximate grey index for the given grey level
    fun <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    fun <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    fun <SID>grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    fun <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    fun <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    fun <SID>rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    fun <SID>color(r, g, b)
        " get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " get the closest color
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return <SID>grey_color(l:gx)
            else
                " use the color
                return <SID>rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    fun <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    fun <SID>X(group, fg, bg, attr)
        if a:fg != ""
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
    endfun
    " }}}
      
   " {{{ Color definitions
   let s:white       = 'e0e0e0'
   let s:lightgrey   = '90998b'
   let s:mediumgrey  = '7a7a7a'
   let s:darkgrey    = '555555'
   let s:black       = '121212'
   let s:lavender    = 'be76bc'
   let s:azure       = '007bff'
   let s:turquoise   = '00afff'
   let s:mint        = '00ff86'
   let s:salmon      = 'ff8470'
   let s:gold        = 'ffd000'
   let s:pink        = 'e8507b'
   let s:lime        = '7bdf00'
   let s:tomato      = 'f24c00'
   let s:orange      = 'e87150'
   " }}}


    " Global
    call <SID>X("Normal", s:white, s:black, "")
    call <SID>X("NonText", s:black, s:black, "")

    " Search
    call <SID>X("Search", "800000", "ffae00", "")
    call <SID>X("IncSearch", "800000", "ffae00", "")
    call <SID>X("IncSearch", "708090", "f0e68c", "")

    " Interface Elements
    call <SID>X("StatusLine", s:white, "3c78a2", "bold")
    call <SID>X("StatusLineNC", s:darkgrey, s:white, "")
    call <SID>X("VertSplit", s:darkgrey, s:darkgrey, "")
    call <SID>X("Folded", "3c78a2", "c3daea", "")
    call <SID>X("Pmenu", s:white, s:azure, "")
    call <SID>X("SignColumn", "", "", "")
    call <SID>X("CursorLine", "", "181818", "")
    call <SID>X("LineNr", s:darkgrey, "202020", "")
    call <SID>X("MatchParen", s:lavender, s:black, "bold")
    call <SID>X("Folded", "888888", "333333", "")
    call <SID>X("Visual", s:white, s:lightgrey, "")

    " Diff
    call <SID>X("DiffAdd", s:lime, "333333", "")
    call <SID>X("DiffChange", s:mint, "333333", "")
    call <SID>X("DiffText", "888888", "333333", "")
    call <SID>X("DiffDelete", s:tomato, "333333", "")
    call <SID>X("ErrorMsg", "888888", "333333", "")

	 " NERDTree
    call <SID>X("NERDTreeDir", s:lavender, "", "")
    call <SID>X("NERDTreeDirSlash", s:lavender, "", "")
    call <SID>X("NERDTreeOpenable", s:lavender, "", "")
    call <SID>X("NERDTreeFile", s:turquoise, "", "")
    call <SID>X("NERDTreeExecFile", s:turquoise, "", "")

    " Specials
    call <SID>X("Todo", s:gold, s:black, "bold")
    call <SID>X("Title", s:lavender, "", "")
    call <SID>X("Special", s:pink, "", "")

    " Syntax Elements
    call <SID>X("String", s:gold, "", "")
    call <SID>X("Constant", s:lavender, "", "")
    call <SID>X("Number", s:lavender, "", "")
    call <SID>X("Statement", s:white, "", "bold")
    call <SID>X("Function", s:turquoise, "", "")
    call <SID>X("PreProc", s:white, "", "bold")
    call <SID>X("Comment", s:darkgrey, "", "")
    call <SID>X("Type", s:mediumgrey, "", "")
    call <SID>X("Error", s:tomato, s:black, "bold")
    call <SID>X("Identifier", s:mint, "", "")
    call <SID>X("Label", s:lime, "", "")

    " Shell Highlighting
    call <SID>X("shVariable", s:pink, "", "")
    call <SID>X("shDeref", s:tomato, "", "")
    call <SID>X("shCommandSub", s:lime, "", "")

    " Asembly Hightlighting
    call <SID>X("asmIdentifier", s:turquoise, "", "")

    " Objective-C Highlighting
    call <SID>X("objcMethodCall", s:pink, "", "")
    call <SID>X("objcInstMethod", s:pink, "", "")
    call <SID>X("objcFactMethod", s:pink, "", "")
   
	 " Lua Highlighting
    call <SID>X("luaTable", s:pink, "", "bold")
    call <SID>X("luaFunc", s:mint, "", "")
    call <SID>X("luaFunction", s:turquoise, "", "bold")

    " Coffee Script
    call <SID>X("coffeeSpecialIdent", s:lime, "", "")
    call <SID>X("coffeeObjAssign", s:turquoise, "", "")
    call <SID>X("coffeeObject", s:pink, "", "bold")
    call <SID>X("coffeeBlock", s:lavender, "", "bold")

    " Python Highlighting
    call <SID>X("pythonBuiltin", s:mint, "", "")
    call <SID>X("pythonException", s:white, "", "bold")
    call <SID>X("pythonExceptions", s:lime, "", "bold")
    call <SID>X("pythonConditional", s:white, "", "bold")
    call <SID>X("pythonRepeat", s:white, "", "bold")
    call <SID>X("pythonOperator", s:white, "", "bold")
    call <SID>X("pythonSpaceError", s:pink, "", "")
    call <SID>X("pythonDoctest", s:pink, "", "")
    call <SID>X("pythonDoctestValue", s:azure, "", "")
    call <SID>X("pythonStatement", s:white, "", "bold")

    " HTML Highlighting
    call <SID>X("htmlTag", s:mint, "", "")
    call <SID>X("htmlEndTag", s:mint, "", "")
    call <SID>X("htmlSpecialTagName", s:azure, "", "")
    call <SID>X("htmlTagName", s:turquoise, "", "bold")
    call <SID>X("htmlTagN", s:turquoise, "", "")

    " Jinja Highlighting
    call <SID>X("jinjaString", s:gold, "", "")
    call <SID>X("jinjaVariable", s:pink, "", "")
    call <SID>X("jinjaAttribute", s:salmon, "", "")
    call <SID>X("jinjaSpecial", s:lime, "", "")

    " Markdown
    call <SID>X("markdownCode", s:gold, "", "")
    call <SID>X("markdownEscape", s:lime, "", "")

    " delete functions {{{
    delf <SID>X
    delf <SID>rgb
    delf <SID>color
    delf <SID>rgb_color
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_color
    delf <SID>grey_level
    delf <SID>grey_number
    " }}}
endif

" vim: set fdl=0 fdm=marker:

