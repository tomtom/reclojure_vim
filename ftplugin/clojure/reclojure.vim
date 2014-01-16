" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    37

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

command -bar -buffer -nargs=1 Finddoc call reclojure#Lookup(<q-args>)
command -bar -buffer -nargs=1 Doc call reclojure#Keyword(<q-args>)
command -bar -buffer -nargs=1 Javadoc call reclojure#JavaDoc(<q-args>)
command -bar -buffer -nargs=? Loadfile call reclojure#LoadFile(empty(<q-args>) ? expand('%:p') : <q-args>)


let b:rescreen_completions='reclojure#Completions'
if empty(&omnifunc)
    setlocal omnifunc=rescreen#Complete
elseif empty(&completefunc) || &omnifunc == &completefunc
    setlocal completefunc=rescreen#Complete
endif


nnoremap <buffer> K :call reclojure#Keyword()<cr>
nnoremap <buffer> <LocalLeader>J :call reclojure#JavaDoc()<cr>
nnoremap <buffer> <localLeader>K :call reclojure#Lookup()<cr>
exec 'nnoremap <buffer>' g:reclojure#mapleader .'s :Loadfile<cr>'

