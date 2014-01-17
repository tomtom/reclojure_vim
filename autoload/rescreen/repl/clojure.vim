" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    73


let s:prototype = {} "{{{2


function! s:prototype.InitBuffer() dict "{{{3
    let automatic_namespace = rescreen#Get('reclojure#automatic_namespace')
    if automatic_namespace >= 1
        let self.initial_exec = 'call reclojure#AutomaticNamespace(0)'
        autocmd ReScreen BufRead,BufWinEnter,WinEnter <buffer> call reclojure#AutomaticNamespace(0)
        if automatic_namespace >= 2
            autocmd ReScreen BufWritePost <buffer> call reclojure#AutomaticNamespace(1)
        endif
    endif
endf


function! s:prototype.ExitRepl() dict "{{{3
    if has_key(self, 'lein_project')
        call self.rescreen.EvaluateInSession('(System/exit 0)', '')
    else
        call self.rescreen.EvaluateInSession('(quit)', '')
    endif
    sleep 1
endf


" function! s:prototype.WrapResultPrinter(input) dict "{{{3
"     let input = a:input
"     <+TODO+>
"     return input
" endf


function! s:prototype.WrapResultWriter(input, xtempfile) dict "{{{3
    let xtempfile = escape(a:xtempfile, '"\')
    let input = ['(spit "'. xtempfile .'" (do '] + a:input + ['))']
    " let input = ['(let [val (do'] + a:input + [
    "             \ '         )]',
    "             \ '  (with-open [w (clojure.java.io/writer  "'. xtempfile .'")]',
    "             \ '    (.write w (str val))))',
    "             \ ]
    return input
endf


" Set the repl to "lein repl" if the current buffer seems to be part of 
" a lein project, i.e. if there is a project.clj around. Otherwise 
" clojure is used.
"
" The working directory has to be set properly -- either by means of 
" 'autochdir' or by |:chdir|.
function! rescreen#repl#clojure#Extend(dict) "{{{3
    let a:dict.terminal = rescreen#Get('reclojure#terminal')
    let a:dict.shell = rescreen#Get('reclojure#shell')
    let a:dict.repl_convert_path = rescreen#Get('reclojure#convert_path')
    let a:dict.repl_handler = copy(s:prototype)
    let lein_project = findfile('project.clj', '.;')
    " TLogVAR a:dict.lein_project
    if !empty(lein_project) && !empty(rescreen#Get('reclojure#lein_repl'))
        let a:dict.repl_handler.lein_project = lein_project
        let a:dict.repldir = fnamemodify(a:dict.repl_handler.lein_project, ':p:h')
        let a:dict.repl = rescreen#Get('reclojure#lein_repl')
    else
        let a:dict.repl = rescreen#Get('reclojure#clojure')
    endif
endf

