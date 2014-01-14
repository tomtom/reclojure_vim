" reclojure.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    41


if !exists('g:reclojure#clojure')
    let g:reclojure#clojure = 'clojure'   "{{{2
endif


if !exists('g:reclojure#lein_repl')
    let g:reclojure#lein_repl = 'lein repl'   "{{{2
endif


if !exists('g:reclojure#shell')
    let g:reclojure#shell = g:rescreen#shell   "{{{2
endif


if !exists('g:reclojure#lookup_cmd')
    if exists('g:netrw_browsex_viewer') && !empty(g:netrw_browsex_viewer)
        let g:reclojure#lookup_cmd = "! ". g:netrw_browsex_viewer ." %s"
    elseif exists('g:vikiOpenUrlWith_ANY') && !empty(g:vikiOpenUrlWith_ANY)
        let g:reclojure#lookup_cmd = substitute(g:vikiOpenUrlWith_ANY, '%{URL}', '%s', '')
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


if !exists('g:reclojure#convert_path')
    let g:reclojure#convert_path = ''   "{{{2
endif


function! reclojure#Completions(base) "{{{3
    let rescreen = rescreen#Init(1, {'repltype': 'clojure'})
    let r = printf('(clojure.string/join " " (apropos #"^%s"))', escape(a:base, '"\'))
    let completions = rescreen.EvaluateInSession(r, 'r')
    " TLogVAR completions
    let clist = split(completions, ' \+')
    " TLogVAR clist
    return clist
endf


function! reclojure#Keyword(...) "{{{3
    let word = a:0 >= 1 && !empty(a:1) ? a:1 : expand("<cword>")
    let r = printf('(doc %s)', word)
    call rescreen#Send(r, 'clojure')
endf


function! reclojure#Lookup(...) "{{{3
    let word = a:0 >= 1 && !empty(a:1) ? a:1 : expand("<cword>")
    let url = printf(g:reclojure#lookup_url, word)
    let cmd = printf(g:reclojure#lookup_cmd, url)
    " TLogVAR cmd
    silent exec cmd
endf

