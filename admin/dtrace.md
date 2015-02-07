# DTrace

## Command

```
dtrace -n <probe> /predicate/ { actions }
```

### Probe

[read][hooked-1] | [read][hooked-3]

```
provider::module::function::name
```

- definition of *event* that will cause clause to *fire*
- names of each probe section are matched from the left and can be omitted
- `dtrace:::BEGIN` == `:::BEGIN` == `BEGIN`

#### provider

- entity providing access to classes of funcions
- `syscall`, `pid`, `objc`

#### module

- depends on provider (some have none)

#### function

- name of the function to trace

#### name

- `entry` matches when function is entered
- `return` matches when function returns
- instruction offset into function

#### DTrace Probes

- `BEGIN`
- `END`
- `ERROR`

### Predicate

- optional test that limits execution of *actions*

```
/execname != "dtrace"/
```

### Action

- script in D language that executes when the *probe* fires
- *flow* of actions is driven by external applications that trigger probes that dtrace is watching
- probes with same name will fire in the order they appear in the D script which can be used to introduce a *flow* and
  execution of some instructions

### Gotchas

[read](http://www.bignerdranch.com/blog/hooked-on-dtrace-part-1/#run-run-away)

- running `sudo dtrace` may not suffice since some DTrace behaviors may not work reliably
- do `sudo -i` or `sudo bash` instead to start a root shell

### Commanline Switches

- `-l` lists all probes matching the the given *probe* 
  - `dtrace -l`
  - `dtrace -l -n 'syscall::read:entry'`
  - `dtrace -l -n 'syscall::read*:entry'`
- `-o` specify output file to write results to
- `-s` specify a `.d` script which contains *predicates* and *actions*
- `-q` run quiet
- `-V` print version

## Providers

- only a few are listed here, more details inside [DTrace Quickstart][quickstart] *Probes/Providers* section

### Pid Provider

- traces userland functions
- `dtrace -l -n 'pid$1:::entry' <pid>` to list all function entry probes in a running process
- `dtrace -l -n 'pid$target:::entry' -c <path to program>` to list all function entry probes in the *program*  

#### ustack

- action that prints the stack when a probe hits

```
dtrace -n 'pid$target::xxx:entry { ustack(); }' -c <program>
```

## Probe Variables and Provider Arguments

[read][quickstart] *Probes/Provider Arguments* section | [read][quickstart] *Data/Variables* section

| variable                |   description                           |
|-------------------------|-----------------------------------------|
| `pid`	                  |  PID of firing process
| `ppid`	                |  PPID of firing process
| `errno`	                |  last errno encountered by the firing process
| `execname`	            |  name of the process firing the probe
| `tid`	                  |
| `probeprov`	            |  provider of the firing probe
| `probemod`	            |  module name of the firing probe
| `probefunc`	            |  function name of the firing probe
| `probename`	            |  name of the firing probe
| `arg0 ... argX`	        |  64 bit integer value returned from a probe
| `args[0] ... args[X]`	  |  typed value returned from a probe

- `args[x]` used by *io* provider, i.e. access `args[2]->fi_pathname`
  - arg*[x]*s refer to struct that varies based on firing probe
- `argx` used by *syscall* provider, i.e. access `save = copyin(arg1, 1);`
  - all arg*x* s are same type (64bit int)

## DTrace Variables

- relative to `dtrace` process
- cast to string via `$$`, i.e if `$1 == 123` then `$$1 == "123"`

| variable              |   description                           |
|-----------------------|-----------------------------------------|
| `$pid`	              | PID of the dtrace process
| `$ppid`	              | PPID of the dtrace process
| `$cwd`	              | current working directory of the dtrace process
| `$0`	                | if called from a script `$0` is the script name
| `$1 ... $9`	          | command line arguments to the dtrace script
| `$target`	            | PID of a traced process when using the `-p` or `-c` switch
| `$[e](g/u)id`	        | effective and real user and group IDs

## Variable Types

- variables are by default global
- `self->x` makes `x` a *thread local* variable
- `this->x` makes `x` a clause/block local variable
- *Arrays* are dynamic and keyed on *Numbers*, *Strings* or a mixture
- *application space pointers* neeed to be copied to dtrace environment via `copyinstr`, i.e. `printf("%s open() by
  %s\n", copyinstr(arg0), execname);`
- *Constants* are declared as `inline`, i.e. `inline int MAX_VALUE = 10;`

## DTrace Aggregations

[read](http://www.bignerdranch.com/blog/hooked-on-dtrace-part-3/#dtrace-aggregates) | [read][quickstart]
*Data/Aggregations*

```
# General Form
@aggregateName[list, of, indexes] = function(expression);

@counts[probefunc]           = count();
@read_amounts[pid, execname] = sum(arg2);

@minw = min(arg0);
@maxw = max(arg0);
@avgw = avg(arg0);
```

## Dtrace Functions

[read][quickstart] *Writing Scripts/Dtrace Funcions*


| function                                                                   |   description                           |
|----------------------------------------------------------------------------|-----------------------------------------|
| `avg(scalar)`                                                              | aggregating function that averages the argument into the aggregation
| `basename(char *pathstr)`                                                  | returns a string containing the file portion (everything right of the last "/" character) in a path name
| `clear(aggregation)`                                                       | clears all data from the aggregation (but leaves the keys - use trunc() to delete data and keys)
| `copyin(uintptr_t addr, size_t size)`                                      | copy size bytes from application space addr to a variable. The destination buffer will be automatically allocated as the return value
| `copyinstr(uintptr_t addr)`                                                | copy a null terminated string from application space addr to a variable. The destination string will be automatically allocated as the return value
| `count(void)`                                                              | aggregating function that increments the aggregation
| `dirname(char *charptr)`                                                   | return a string with just the directory path (everything to the left of the last "/" character) and not the file portion of a full path/file input string
| `exit(int status)`                                                         | exit the dtrace script with a return value of status
| `lquantize(scalar expression, int lower_bound, int upper_bound, int step)` | an aggregating function that generates a linear distribution of the input scalar expression. The 2nd, 3rd, and 4th parameters define the bounds and step of the distribution. (For a simpler, power of two distribution used quantize().)
| `max(scalar)`                                                              | aggregating function that sets the aggregation to the maximum value supplied.
| `min(scalar)`                                                              | aggregating function that sets the aggregation to the minimum value supplied.
| `panic(void)`                                                              | this is a destructive call that will cause the system to panic.
| `printa(aggregation)`, `printa(string format, aggregation)`                | Explicitly print an aggregation to the output buffer or print an aggregation using a format string.
| `printf(string format, ...)`                                               | print to the output buffer using printf(3) syntax
| `quantize(scalar expression)`                                              | an aggregating function that generates a power of two distribution of the input scalar expression. (For a linear distribution used lquantize().
| `stringof(expression)`                                                     | converts input expression to a string
| `sum(scalar)`                                                              | aggregating function that adds the input to the aggregation
| `system(string program-format, ...)`                                       | call the program specified in the format string
| `trace(expression)`                                                        | trace the expression to the output buffer
| `tracemem(uintptr_t address, size_t bytes)`                                | dump (print) a memory location to the output buffer. The address must be local to the dtrace process (ie: use copyin() on the address first) and the second parameter must be a constant (it cannot be a variable)
| `trunc(aggregation)`                                                       | clears all data and keys from the aggregation (use clear() to delete data and maintain the keys

## Useful Scripts 

List all *modules* available in a program.

```
dtrace -l -n 'pid$target:::entry' -c <program> | awk '{print $3}' | sort | uniq
```

Print stack *10* deep each time *any* function is entered.

```
dtrace -n 'pid$target:::entry { ustack(10); }' -c <program>
```

List system calls and the number each got called.

```
dtrace -n 'syscall:::entry { @counts[probefunc] = count(); }' -c <program>
```

Print the time it took each call to `malloc` to run.

```awk
pid$target::malloc:entry {
    # self to be thread local
    self->entry_time = timestamp;
}

pid$target::malloc:return
/self->entry_time/ {
    # this to get a variable local to this function
    this->delta_time = timestamp - self->entry_time;
    printf ("the call to malloc took %d ns", this->delta_time);
    self->entry_time = 0;
}
```

Keep count of functions called, including stack *5* deep and print the top *20* once dtrace script exits.

```awk
pid$target::::entry {
    @stacks[ustack(5)] = count();
}

END {
    trunc (@stacks, 20);
}

#   node`v8::internal::StringHasher::GetHashField()
#   node`v8::internal::AstValueFactory::GetOneByteStringInternal(v8::internal::Vector<unsigned char const>)+0x165
#   node`v8::internal::ParserBase<v8::internal::ParserTraits>::ParseIdentifier(v8::internal::ParserBase<v8::internal::ParserTraits>::AllowEvalOrArgumentsAsIdentifier, bool*)+0x63
#   node`v8::internal::ParserBase<v8::internal::ParserTraits>::ParsePrimaryExpression(bool*)+0x153
#   node`v8::internal::ParserBase<v8::internal::ParserTraits>::ParseMemberExpression(bool*)+0xda
# 17612
# [ .. ]
```

## Resources

- [Hooked on DTrace, part 1][hooked-1]
- [Hooked on DTrace, part 2][hooked-2]
- [Hooked on DTrace, part 3][hooked-3]
- [Hooked on DTrace, part 4][hooked-4]
- [DTrace Quickstart][quickstart]
- [dtrace.org guide][guide]
- [DTrace One Liners by Brendan Gregg][one-liners]
- [DTrace One Liners FreeBSD][one-liners-freebsd]


[hooked-1]:http://www.bignerdranch.com/blog/hooked-on-dtrace-part-1/
[hooked-2]:http://www.bignerdranch.com/blog/hooked-on-dtrace-part-2/
[hooked-3]:http://www.bignerdranch.com/blog/hooked-on-dtrace-part-3/
[hooked-4]:http://www.bignerdranch.com/blog/hooked-on-dtrace-part-4/

[quickstart]:http://www.tablespace.net/quicksheet/dtrace-quickstart.html
[guide]:http://dtrace.org/guide
[one-liners]:http://www.brendangregg.com/DTrace/dtrace_oneliners.txt
[one-liners-freebsd](https://wiki.freebsd.org/DTrace/One-Liners)
