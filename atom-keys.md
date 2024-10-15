
#

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



