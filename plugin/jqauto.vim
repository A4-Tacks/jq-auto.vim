let g:jqauto_jqwinsize = get(g:, 'jqauto_jqwinsize', 2)
let g:jqauto_timeout = get(g:, 'jqauto_timeout', '1s')

function! jqauto#init()
    command! -buffer -nargs=* -bar JQOpen
                \ call jqauto#open(<q-args>)
endfunction

function! jqauto#open(args) abort
    let t:jqauto_args = a:args
    let t:jqauto_current_bufid = bufnr()

    let bufid = get(t:, 'jqauto_bufid')
    let winid = bufwinnr(bufid)

    if winid != -1
        exe winid 'winc q'
    endif
    silent exe g:jqauto_jqwinsize 'new' (bufid ? '#'.bufid : '')
    let t:jqauto_bufid = bufnr()
    silent file jqauto.jq
    setf jq
    setlocal nobuflisted noswapfile nowrite

    if !bufid
        call setbufline(t:jqauto_bufid, 1, '.')
    endif

    aug jqauto
        au TextChanged,TextChangedI,InsertLeave <buffer> call jqauto#update()
    aug end

    call jqauto#update()

    star!
endfunction

function! jqauto#update() abort
    setlocal nomodified
    let bufid = t:jqauto_current_bufid
    let curline = getcurpos(bufwinnr(bufid))[1]
    let inputs = getbufline(bufid, 1, curline)
    let script = join(getbufline(t:jqauto_bufid, 1, '$'), "\n")

    let cmd = $'timeout {shellescape(g:jqauto_timeout)}'
                \.$' jq {shellescape(script)} {t:jqauto_args}'
    let outputs = system(cmd, inputs)

    let status = $'// jq ... {t:jqauto_args}; ({v:shell_error}) outputs:'
    call deletebufline(bufid, curline+1, '$')
    call appendbufline(bufid, '$', status)
    for line in split(outputs, '\n')
        call appendbufline(bufid, '$', line)
    endfor
endfunction
