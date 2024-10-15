'.platform-darwin, .platform-win32, .platform-linux':
  'cmd-g': 'go-to-line:toggle'
  'cmd-n': 'tree-view:add-file'

'.workspace .editor:not(.mini)':
  'cmd-shift-L': 'line-numbers:toggle'
  'cmd-ctrl-l': 'line-numbers:toggle'
  'alt-down': 'line-jumper:move-down'
  'alt-up': 'line-jumper:move-up'
  'cmd-[': 'editor:fold-current-row'
  'cmd-]': 'editor:unfold-current-row'
  'cmd-g': 'go-to-line:toggle'
  'cmd-shift-B': 'atom-beautify:beautify-editor'
  'cmd-n': 'tree-view:add-file'
  'ctrl-right': 'editor:move-to-next-word-boundary'
  'ctrl-shift-right': 'editor:select-to-next-word-boundary'
  'ctrl-left': 'editor:move-to-previous-word-boundary'
  'ctrl-shift-left': 'editor:select-to-previous-word-boundary'
  'ctrl-cmd right': 'pane:split-right'
  'ctrl-cmd left': 'pane:split-left'
  'ctrl-cmd down': 'pane:split-down'
  'ctrl-cmd up': 'pane:split-up'

https://vim.rtorr.com/
:Zen

MOTIONS
e word end
C-o go back buffer
C-i go forward buffer
C-6 C-^ jump between buffers back and forth
]d - next error
]D - last error
spc e - show errors
spc q - quickfix list
gd - go to definition (lsp)
gr - go to reference (lsp)
b-b / f - forward and back page
C-u / d - forward and back 1/2 page
} / {  - end of block / before it
[ / ] - end of inner block
I - start writing at start 
f space goes to next space, etc. ft fa f"

END motions

LAYOUTS
spc s -/= -split size
:resize [+-]N - resize a horizontal split, increasing or decreasing height by N characters.
:vertical resize [+-]N - resize a vertical split, increasing or decreasing height by N characters.
:resize N - resize a horizontal split, setting height to N characters.
:vertical resize N - resize a vertical split, setting width to N characters.
C-a - mouse mode
cmd Enter - new window
cmd r - resize window
c-L l - layout window
spc sn - next split focus
spc sh/sl - split horizontally
spc sv/sj - split vertically
sc sx - close split
spc se - split equal size
spc to - new tab
spc tx - tab close
spc tn - tab next
spc tp - tab prev
spc tf - open current buffer in new tab
END layouts

SEARCHING / FILES
spc tk search keymaps
spc tf - search files
spc ts - search select telescope
spc tw - search current word
spc tt file explorer
spc ff - search live grep
spc td - search errors
spc tr - search resume
spc t. - search recent files
spc spc - find existing buffers
spc / - fuzzy find?
spc s/ - live find
spc sn - search neovim
:e newfolder/newfile.js
END searching / files

ACTIONS / EDITS
search / replace
spc F - currently format
=G from beginning to format all
C-n - re-apply macro .
/{q}<Ent> - search
?{q}<Ent> - search backwards
%{q} - search matching
C-q quickfix after a telescope search - replace
n - next 
N - last
C-j/k - move line up down
:s/{old}/{new}/g - substitute global
:s/{old}/{new} - substitute first
:{#},{#}s/{old}/{new}/g
:%s/{old}/{new}/g - change every occurence
:%s/{old}/{new}/gc - change every occurence with prompt
* search current word under cursor
. then this to make changes like ciw apply
viw select word 
3@p applies for 3 rows
"3p" third register paste
qh start macro at h
zfa{
zd undo fold
zt zz zb move line around
vib / viB braces / curly braces pull
yiw put a character around word
yi" copies all inside quote
. repeats it
C-o while in insert mode can take a command
C-spc autocomplete
ysa 
dst delete surrounding tag
> < indent / can do >2j
>a{
>i}
z fold
% jump to next of type like { to end }
guW / guw / guu / gUU - upper / lowercases
ctrl-x -ctrl-a increment / decrement
ZZ save and quit
ZQ quit
nvim-surround

gx open url
gf open file
ttest-this-theory;:m  mest-this-theory;:mm
The 3 ops of add/delete/change with keymaps ys{motion}{char}, ds{char}, and cs{target}{replacement}
 * will denotes cursor pos
    Old text                    Command         New text m
--------------------------------------------------------------------------------
    surr*ound_words             ysiw)           (surround_words)
    *make strings               ys$"            "make strings"
    [delete ar*ound me!]        ds]             delete around me!
    remove <b>HTML t*ags</b>    dst             remove HTML tags
    'change quot*es'            cs'"            "change quotes"
    <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    delete(functi*on calls)     dsf             function calls

c$ - delete to end of line and insert
cc or S - change (replace) entire line
r$ - replace to end?
c - change
ce - change word
y - yank (in visual mode)
J - join two lines
yw - yank word
y:1,10 - yank between
gc2j - comment / uncomment
gc}
gca( - around (
gci{ - inside brackets
ciw - change word
ci" - "testing"
W - word with space
spc - spc = - increment
q - skip one
C-n - select and make cursors in word // can be used at the /search instead of n too, n would skip?
C-LeftMouse - create cursor where clicked
C-RightMouse - select a word where clicked
END actions / edits

WHOOPS
u - undo
cmd-u redo
U - undo all?
C-r - redo
todo above as U
spc sh - search help
lookup that other tree based undo
END whoops


MASTERED
w word start
b preview word
0 - start of line
$ - end of line
gg - jump to start
G - jump to end
:99 or 99G jump to line
i - insert before cursor
a - insert after cursor
A - start insert at end of line
o - insert line after
O - insert line before
R - insert replace
x - delete char
spc lkj - back to reg mode:
dd - delete line
dw - delete word
d$ - delete to end of line
p - paste
r - replace current 
P - paste before cursor
spc oi - window
spc ee file tree view
spc ja,s,d,f harpoon
spc a add harpoon
spc l list harpoon
C-up / down - make cursors
d$ - delete to end of line
spc m{mark} - go to mark
m{anything} set a mark (capital for file across)
`{anything} go to a mark (capital for file across)
