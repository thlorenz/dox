## Autoconf

- Write your program, keeping portability in mind
- create `Makefile.in`
- Run `autoscan`.
- Rename `configure.scan` to `configure.ac`
- Run `autoheader`.
- Run `autoconf`.
- `./configure`.
- Check `config.h`. If necessary, modify source and repeat from step #2.
- And lastly, compile!

### Sources

[Autotools Tutorial for Beginners - Autoconf](http://markuskimius.wikidot.com/programming:tut:autotools:3)

## Automake

- Create `Makefile.am`.
- Run `automake`.
- Fix error messages.
- Run `aclocal`.
- Autoconf everything.
- Configure, compile, and enjoy!

### Sources

[Autotools Tutorial for Beginners - Automake](http://markuskimius.wikidot.com/programming:tut:autotools:4)


## Autoconf and Automake Combined

- Create your sources. (Be sure to have a simple `Makefile` to help Autoconf autodetect things better.)
- Run `autoscan` to generate `configure.scan`.
- Rename `configure.scan` to `configure.ac`.
- Run `autoheader` to generate `config.h.in`.
- Make your source portable by looking at `config.h.in`. (We previously did this at a later step by reading `config.h`, but we can do it in this step by referring to `config.h.in` instead.)
- Create `Makefile.am`.
- Run `automake`.
- Fix errors and run `automake` again.
- Run `aclocal`.
- Run `autoconf`.
- Configure, make, and run!

### Sources

[Autotools Tutorial for Beginners - Combined](http://markuskimius.wikidot.com/programming:tut:autotools:5)

## Checkin

Check in the following derived/generated files:

- Makefile.am
- configure.ac
- README.md (link README and NEWS to it)
- LICENSE (link COPYING to it)

Ignore the following files:

```
Makefile
Makefile.in
autom4te.cache/
autoscan.log
config.log
config.status
configure
config.*
configure.*
*.o
.deps/
AUTHORS
COPYING
ChangeLog
INSTALL
NEWS
README
compile
depcomp
install-sh
missing
stamp-h
```
