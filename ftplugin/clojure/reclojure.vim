" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    9

if exists("b:did_reclojure")
    finish
endif
let b:did_reclojure = 1


Rescreen clojure

if empty(&omnifunc)
    setlocal omnifunc=reclojure#Complete
elseif empty(&completefunc) || &omnifunc == &completefunc
    setlocal completefunc=reclojure#Complete
endif

nnoremap <buffer> K :call reclojure#Keyword()<cr>
nnoremap <buffer> <localleader>K :call reclojure#Lookup()<cr>

