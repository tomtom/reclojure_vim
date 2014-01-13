" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    11

if exists("b:did_reclojure")
    finish
endif
let b:did_reclojure = 1


Rescreen -default clojure


let b:rescreen_completions='reclojure#Completions'
if empty(&omnifunc)
    setlocal omnifunc=rescreen#Complete
elseif empty(&completefunc) || &omnifunc == &completefunc
    setlocal completefunc=rescreen#Complete
endif


nnoremap <buffer> K :call reclojure#Keyword()<cr>
nnoremap <buffer> <localleader>K :call reclojure#Lookup()<cr>

