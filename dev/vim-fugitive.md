# Git shorthands

- `:Git add %`      =  `:Gwrite`	Stage the current file to the index
- `:Git checkout %` =  `:Gread`	  Revert current file to last checked in version
- `:Git rm %`       =  `:Gremove`	Delete the current file and the corresponding Vim buffer
- `:Git mv %`       =  `:Gmove`	  Rename the current file and the corresponding Vim buffer `/` is root of git repo

- `:Git commit`     =  `Gcommit` Opens new vim buffer allowing committing changes
- `:Git blame %`    =  `Gblame` Opens vsplit buffer showing commits and committer

# Git Status

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

# Git index

- `:Gedit :path/to/file` opens indexed (last staged/committed) version of the file
- `:Gedit :0` opens indexed version of current file
- `:Gdiff` diffs current file' working copy with the one in the index
- `:Gwrite` from index file == `:Gread` from working copy and vice versa
- in diff view diffput and diffget followed by writing index file allows staging hunks of code (visual mode is
  supported)

# Merging

- `:Gdiff` on file with conflicts opens 3 way split (target|working with conflicts|merge)
- fugitive names working and merge files consistently as `//2/filename` and `//3/filename` respectively which allows
  using these as bufspecs: ( `//2` | `name` | `//3` )
- **a)** keep focus in middle buffer and use `diffget //2` or `diffget //3` resolve conflict with target or merge respectively
- **b)** focus the buffer whose change to keep and `dp` (fugitive ensures that all puts go into working copy = middle
  buffer and automatically runs diffupdate)
- `:Gwrite` from working buffer finishes merge and removes splits
- `:Grwite!` from merge takes all changes from it

# Browsing git object database

## Gedit 

- `:Gedit branch:path/to/file` opens readonly version (in order to change it, first switch to the branch)
- `:Gvsplit` runs `:Gedit` in a new vertical split
- `:Gedit sha` opens that commit in new buffer (same as `git show sha`). `Enter` on a line with a sha opens it in current 
  buffer, allowing to travel back in time
- trees and files in a tree can be followed and diffs opened via `Enter` on the corresponding line
- `:edit %:h` opens parent tree

## Gbrowse

- opens current `branch:file` on github
- supports visual selection (i.e. highlights selected lines in github)
- `:Gedit HEAD^` followed by `:Gbrowse` opens remote url for that commit object
- `:Gbrowse` while cursor is over tree line, opens up that tree on github

# Git History

## Previous Commits

- `:Glog` switches to recently checked in version of file and adds previous versions to quickfix, `cnext` (`]q`), `cprev`
  (`[q`) navigate through them. Return to working copy via `:Gedit`
- `:Glog` supports `git log` flags:
  - `:Glog -10` loads only last 10 revisions
  - `:Glog -10 --reverse` loads only first 10 revisions
  - `:Glog -1 --until=yesterday` loads last version of file checked in yesterday
  - `:Glog --` Loads all previous commits into quickfix
  - `:Glog -- %` Loads all previous commits that touch current file into quickfix

## Searching

### Inside comitted files

- `:Ggrep` wraps `git grep`, i.e. `git grep highlight | view -` and puts all matches into quickfix window
- `:Ggrep 'find me' [branch|tag|sha]` searches through files at that particular place

### Inside commit messages

- `:Glog --grep=term --` is same as `git log --grep=term` (added to quickfix list of interactive commit buffers)
- `:Glog -Sterm --` same as `git log -Sterm` - shows commits where term was added or removed
