" reclojure.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    80


if !exists('g:reclojure#clojure')
    let g:reclojure#clojure = 'clojure'   "{{{2
endif


if !exists('g:reclojure#lein_repl')
    let g:reclojure#lein_repl = 'lein repl'   "{{{2
endif


if !exists('g:reclojure#terminal')
    let g:reclojure#terminal = g:rescreen#terminal   "{{{2
endif


if !exists('g:reclojure#shell')
    let g:reclojure#shell = g:rescreen#shell   "{{{2
endif


if !exists('g:reclojure#mapleader')
    let g:reclojure#mapleader = g:rescreen#mapleader   "{{{2
endif


if !exists('g:reclojure#automatic_namespace')
    " If 1, automatically switch namespaces when switching buffers.
    " If 2, also reload files when saving.
    let g:reclojure#automatic_namespace = 2   "{{{2
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
    " If empty, use (find-doc).
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
    let r = printf('(clojure.repl/doc %s)', word)
    call rescreen#Send(r, 'clojure')
endf


function! reclojure#JavaDoc(...) "{{{3
    let word = a:0 >= 1 && !empty(a:1) ? a:1 : expand("<cword>")
    let r = printf('(clojure.java.javadoc/javadoc %s)', word)
    call rescreen#Send(r, 'clojure')
endf


function! reclojure#Lookup(...) "{{{3
    let word = a:0 >= 1 && !empty(a:1) ? a:1 : expand("<cword>")
    if empty(g:reclojure#lookup_url)
        let r = printf('(clojure.repl/find-doc #"^%s")', escape(word, '"'))
        call rescreen#Send(r, 'clojure')
    else
        let url = printf(g:reclojure#lookup_url, word)
        let cmd = printf(g:reclojure#lookup_cmd, url)
        " TLogVAR cmd
        silent exec cmd
    endif
endf


function! reclojure#LoadFile(...) "{{{3
    let filename = a:0 >= 1 && !empty(a:1) ? a:1 : expand("%:p")
    let r = printf('(clojure.core/load-file "%s")', escape(filename, '\"'))
    call rescreen#Send(r, 'clojure')
endf


function! reclojure#AutomaticNamespace(reload) "{{{3
    " TLogVAR expand('%')
    if exists('b:rescreens')
        let rescreen = b:rescreens.clojure
        let view = winsaveview()
        try
            1
            let rx = '^\s*(ns\_s\+\S'
            if search(rx, 'ceW')
                let ns = expand('<cword>')
                if empty(ns) || !has_key(rescreen.repl_handler, 'lein_project')
                    call reclojure#LoadFile()
                else
                    " let r = printf('(clojure.core/use ''%s)', ns)
                    let r = printf('(clojure.core/use ''%s :reload)', ns)
                    if !a:reload
                        let r .= printf('(clojure.core/in-ns ''%s) (clojure.core/refer ''clojure.core) (refer ''clojure.repl)', ns)
                    endif
                    call rescreen#Send(r, 'clojure')
                endif
            endif
        finally
            call winrestview(view)
        endtry
    endif
endf

