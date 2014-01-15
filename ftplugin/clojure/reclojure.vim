" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    26

if exists("b:did_reclojure")
    finish
endif
let b:did_reclojure = 1


Rescreen -default clojure


command -bar -buffer -nargs=* Lein Rescreen! -wait bash lein <args>
command -bar -buffer -nargs=* Leintest Rescreen! -wait bash lein test <args>
command -bar -buffer -nargs=* Leinretest Rescreen! -wait bash lein retest <args>
command -bar -buffer -nargs=* Leinrerun Rescreen! -wait bash lein run <args>
command -bar -buffer -nargs=* Leintyped Rescreen! -wait bash lein typed check <args>


let b:rescreen_completions='reclojure#Completions'
if empty(&omnifunc)
    setlocal omnifunc=rescreen#Complete
elseif empty(&completefunc) || &omnifunc == &completefunc
    setlocal completefunc=rescreen#Complete
endif


nnoremap <buffer> K :call reclojure#Keyword()<cr>
nnoremap <buffer> <localleader>K :call reclojure#Lookup()<cr>

