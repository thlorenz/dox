# Git shorthands

- `:Git add %`      =  `:Gwrite`	Stage the current file to the index
- `:Git checkout %` =  `:Gread`	  Revert current file to last checked in version
- `:Git rm %`       =  `:Gremove`	Delete the current file and the corresponding Vim buffer
- `:Git mv %`       =  `:Gmove`	  Rename the current file and the corresponding Vim buffer `/` is root of git repo

- `:Git commit`     =  `Gcommit` Opens new vim buffer allowing committing changes
- `:Git blame %`    =  `Gblame` Opens vsplit buffer showing commits and committer
- `

# Git index

- `:GStatus` brings up buffer with list of staged/unstaged/untracked files
- `Ctrl-n, Ctrl-p` navigate between filenames
- `-` on unstaged file will stage it = `git add` on that file 
- `-` on staged file will unstage it = `git reset` on that file
- both support visual mode for batch adding/resetting
- `p` on file = `git add --patch` splits file into hunks of changes and allows selecting which ones will be added to
  index

## Reviewing changes

- `Enter` in status window open file under cursor
- `:Gdiff` shows diff of changes
