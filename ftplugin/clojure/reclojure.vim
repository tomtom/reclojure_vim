" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    20

if exists("b:did_reclojure")
    finish
endif
let b:did_reclojure = 1


Rescreen -default clojure


command -bar -buffer -nargs=* Leintest Rescreen! bash lein test <args> || read
command -bar -buffer -nargs=* Leinretest Rescreen! bash lein retest <args> || read
command -bar -buffer -nargs=* Leinrerun Rescreen! bash lein run <args> || read
command -bar -buffer -nargs=* Leintyped Rescreen! bash lein typed check <args> || read


let b:rescreen_completions='reclojure#Completions'
if empty(&omnifunc)
    setlocal omnifunc=rescreen#Complete
elseif empty(&completefunc) || &omnifunc == &completefunc
    setlocal completefunc=rescreen#Complete
endif


nnoremap <buffer> K :call reclojure#Keyword()<cr>
nnoremap <buffer> <localleader>K :call reclojure#Lookup()<cr>

