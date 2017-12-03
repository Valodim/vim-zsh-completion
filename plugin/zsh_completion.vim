" zsh_completion.vim - Omni Completion for zsh
" Maintainer: Valodim Skywalker <valodim@mugenguild.com>
" Last Updated: 03 Oct 2013
" 
let s:pos = 0
let s:str = ''
let s:base = ''

fun! zsh_completion#Complete(findstart, base)

    if a:findstart
        let str = getline('.')[:col('.') - 2]
        let s:str = substitute(str, '[^ ]*$', '' , 'g')
        let s:pos = len(s:str)
        let s:base = str[s:pos :]
        return s:pos
    else

        let l:srcfile = globpath(&rtp, 'plugin/capture.zsh')
        if len(l:srcfile) == 0
            return -1
        endif

        let s:out = system(l:srcfile . ' ' . shellescape(s:str . s:base) . ' ' . (col('.')+strlen(s:base)-1))
        let l:result = []
        for item in split(s:out, '\r\n')
            let l:pieces = split(item, ' -- ')
            if len(l:pieces) > 1
                call add(l:result, { 'word': l:pieces[0], 'menu': l:pieces[1] })
            else
                call add(l:result, { 'word': l:pieces[0] })
            endif
        endfor
        return {'words': l:result, 'refresh': 'always'}

    endif
endfun

" vim: set et ts=4:
