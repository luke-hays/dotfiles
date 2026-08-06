" this is based off my work config, trying to be better about implementing and
" understanding rules instead of chucking in a billion settings from an
" opinionated config
"
" :help in vim to explain what a lot of these do

filetype plugin indent on
syntax on

if has('termguicolors')
  set termguicolors
endif

" colorscheme example
" set background=dark
" colorscheme kanagawa

runtime macros/matchit.vim
set autoindent
set backspace=indent,eol,start
set hidden
set incsearch
set wildmenu

" useful for jumps
set relativenumber

" show current position
set ruler

" ignore case on search
set ignorecase

" show matching brackets when text indicator is over them
set showmatch

" tab settings
set expandtab
set softtabstop=4
set shiftwidth=4
set tabstop=4

" --- LSP (yegappan/lsp) ---
packadd lsp

if exists('*g:LspAddServer')
  let s:lspServers = [
        \ {
        \   'name': 'ty',
        \   'filetype': ['python'],
        \   'path': exepath('ty'),
        \   'args': ['server']
        \ }
        \ ]

  call g:LspAddServer(s:lspServers)

  call g:LspOptionsSet({
        \ 'autoComplete': v:true,
        \ 'autoHighlight': v:true,
        \ 'autoHighlightDiags': v:true,
        \ 'showDiagWithVirtualText': v:false,
        \ 'showInlayHints': v:true,
        \ 'popupBorder': v:true,
        \ 'autoPopulateDiags': v:true,
        \ })

  " Show the current line's diagnostic(s) in a bordered popup that always
  " wraps. The plugin's own LspDiagCurrent popup only wraps when the message
  " is wider than the whole screen; this reads the diagnostic text from the
  " auto-populated location list (id stashed in b:LspQfId) and renders it with
  " wrap:true + a fixed maxwidth so long messages always wrap inside the box.
  function! s:DiagPopup() abort
    let l:id = get(b:, 'LspQfId', 0)
    if l:id == 0
      echo 'No diagnostics'
      return
    endif
    let l:msgs = []
    for l:item in getloclist(0, {'id': l:id, 'items': 1}).items
      if l:item.lnum == line('.')
        call extend(l:msgs, split(l:item.text, "\n"))
      endif
    endfor
    if empty(l:msgs)
      echo 'No diagnostic on this line'
      return
    endif
    call popup_atcursor(l:msgs, {
          \ 'border': [],
          \ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
          \ 'wrap': v:true,
          \ 'maxwidth': 60,
          \ 'moved': 'any',
          \ 'padding': [0, 1, 0, 1],
          \ })
  endfunction

  function! s:LspKeymaps() abort
    nnoremap <buffer> gd <Cmd>LspGotoDefinition<CR>
    nnoremap <buffer> gr <Cmd>LspShowReferences<CR>
    nnoremap <buffer> K  <Cmd>LspHover<CR>
    nnoremap <buffer> <leader>rn <Cmd>LspRename<CR>
    nnoremap <buffer> <leader>ca <Cmd>LspCodeAction<CR>
    nnoremap <buffer> [d <Cmd>LspDiagPrev<CR>
    nnoremap <buffer> ]d <Cmd>LspDiagNext<CR>
    " full diagnostic message in a bordered, always-wrapping popup box
    nnoremap <buffer> <leader>e <Cmd>call <SID>DiagPopup()<CR>
    " location-list of all diagnostics in the buffer, full text
    nnoremap <buffer> <leader>q <Cmd>LspDiagShow<CR>
  endfunction

  augroup LspKeymaps
    autocmd!
    autocmd User LspAttached call s:LspKeymaps()
  augroup END
endif
