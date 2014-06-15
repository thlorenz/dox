## File Operations

### Find then copy multiple files

#### Linux

```sh
find -name '*foo*' -print0 | xargs -0 cp -t ./target 
```

*the `-t` flag is a GNU extension to `cp`*

#### MacOS

BSD `find`

```sh
find . -name *foo* | xargs -I{} cp {} ./target 
# or
find . | grep foo | xargs -I{} cp {}  ./target
```

#### Linux and MacOS

```sh
find . -iname *foo* -exec cp "{}" ./target  \;
```

[stackoverflow](http://stackoverflow.com/questions/143171/how-can-i-use-xargs-to-copy-files-that-have-spaces-and-quotes-in-their-names/149026#149026)
