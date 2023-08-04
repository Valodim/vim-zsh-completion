" zsh_completion.vim - Omni Completion for zsh
" Maintainer: Valodim Skywalker <valodim@mugenguild.com>
" Last Updated: 03 Oct 2013

let s:srcfile = globpath(&runtimepath, 'autoload/capture.zsh')
let s:hasSrcfile = len(s:srcfile)

fun! zsh_completion#Complete(findstart, base) abort

    if a:findstart
        " locate the start of the word
        let l:line = getline('.')
        let l:pos = col('.') - 1
        while l:pos > 0 && l:line[l:pos - 1] =~? '\S'
            let l:pos -= 1
        endwhile

        " SAVE THE BASE OURSELVES
        " For some weird reason, if the base for completion is just '-', which
        " is the case fairly often in shell completion, the a:base argument we
        " get below is just '0'. I don't know why, it just does. So I'm saving
        " it here myself as a workaround. If anyone knows how to fix this or
        " what I'm doing wrong, I'd be happy to hear it.
        let s:base = l:line[l:pos :]

        return l:pos
    else

        if s:hasSrcfile == 0
            return -1
        endif

        let s:out = system(s:srcfile . ' ' . shellescape(getline('.') . s:base) . ' ' . (col('.')+strlen(s:base)-1))
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
