# https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md

# <!-- copy to ~/.config/lazygit/config.yaml -->

keybinding:
  override: true
  gui:
    nerdFontsVersion: "3"
  universal:
    # prevItem-alt: 'k'  #h
    # nextItem-alt: 'l'  #t
    # prevBlock-alt: 'h' #k
    # nextBlock-alt: 't' #l 
    prevItem-alt: 'h'  #h
    nextItem-alt: 't'  #t
    prevBlock-alt: 'k' #k
    nextBlock-alt: 'l' #l 
    nextMatch: 'n'
    prevMatch: 'N'
    # new: 'k'
    edit: 'o'
    openFile: 'O'
    scrollUpMain-alt1: 'H'
    scrollDownMain-alt1: 'T'
    undo: 'u'
    redo: '<c-r>'
  commits:
    revert: 'U'
  files:
    ignoreFile: 'I'
    # scrollUpMain-alt2: '<leader-k>'
    # scrollDownMain-alt2: '<leader-l>'
    # scrollUpMain-alt2: 'h'
    # scrollDownMain-alt2: 't'
