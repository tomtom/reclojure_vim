" reclojure.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    30


if !exists('g:reclojure#lookup_cmd')
    if executable("firefox")
        let g:reclojure#lookup_cmd = "! firefox %s &"
    elseif has("win32") || has("win64")
        " let g:reclojure#lookup_cmd = "! RunDll32.EXE URL.DLL,FileProtocolHandler %s"
        let g:reclojure#lookup_cmd = "! start %s"
    elseif has("mac")
        let g:reclojure#lookup_cmd = "!open %s"
    elseif $GNOME_DESKTOP_SESSION_ID != ""
        let g:reclojure#lookup_cmd = "!gnome-open %s"
    elseif exists('$XDG_CURRENT_DESKTOP') && !empty($XDG_CURRENT_DESKTOP)
        let g:reclojure#lookup_cmd = "!xdg-open %s"
    elseif $KDEDIR != ""
        let g:reclojure#lookup_cmd = "!kfmclient exec %s"
    endif
endif


if !exists('g:reclojure#lookup_url')
    let g:reclojure#lookup_url = 'http://clojuredocs.org/search?q=%s'   "{{{2
endif


function! reclojure#Complete(findstart, base) "{{{3
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '[._[:alnum:]]'
            let start -= 1
        endwhile
        return start
    else
        let rescreen = rescreen#Init(1, {'repltype': 'clojure'})
        let r = printf('(clojure.string/join " " (apropos "%s"))', escape(a:base, '"\'))
        let completions = rescreen.EvaluateInSession(r, 'r')
        " TLogVAR completions
        let clist = split(completions, ' \+')
        " TLogVAR clist
        return clist
    endif
endf


function! reclojure#Keyword(...) "{{{3
    let word = a:0 >= 1 && !empty(a:1) ? a:1 : expand("<cword>")
    let name = word
    " let name = string(word)
    let r = printf('(doc %s)', name)
    call rescreen#Send(r, 'clojure')
endf


function! reclojure#Lookup(...) "{{{3
    let word = a:0 >= 1 && !empty(a:1) ? a:1 : expand("<cword>")
    let url = printf(g:reclojure#lookup_url, word)
    let cmd = printf(g:reclojure#lookup_cmd, url)
    " TLogVAR cmd
    silent exec cmd
endf

