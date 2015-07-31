function! s:get_visual_selection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! RetrieveOldComments() 
let line = s:get_visual_selection()
let outputString = substitute(system("echo \"".line."\" | grep -Po \"(?<=\\{\\|).*(?=\\|\\})\""), "\n*$", '', '')
let dateString = substitute(system("date -d \"$(echo \"".outputString."\" | sed -e 's/_[h]/ /g' -e 's/[a-z]//g' -e 's/_/-/g' -e 's/-/:/3g')\" +%s"), "\n*$", '', '') 
let currentFileName = expand('%:t')
let commitNumber = substitute(system("git log --after=\"".dateString."\" --reverse | head -1 | sed 's/commit//g'"), '^\s*\(.\{-}\)\s*$', '\1', '')
let window_name = " ".currentFileName."--".commitNumber
"echo "LINE: ".line
"echo "WINDOW NAME: ".window_name
"echo "OUTPUT_STRING: ".outputString
"echo "dateString: ".dateString
"echo "commitNumber: ".commitNumber


execute "vsp".window_name
execute "read ! git show ".commitNumber.":".currentFileName
redraw  
execute "/".outputString

endfunction

noremap <F5> %
noremap <F3> v% :call RetrieveOldComments()<CR>

inoremap <F7> <C-R>=strftime("{\| y%Y_m%m_d%d \|}")<CR>
inoremap <F8> <C-R>=strftime("{\| h%H_m%M_s%S \|}")<CR>
inoremap <F9> <C-R>=strftime("{\| y%Y_m%m_d%d_h%H_m%M_s%S \|}")<CR>


