<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [SIGPROF](#sigprof)
  - [Handling Signals](#handling-signals)
  - [Thread-directed Signals](#thread-directed-signals)
  - [Timers](#timers)
  - [Overhead](#overhead)
  - [Signal Handler Limitations](#signal-handler-limitations)
  - [Resources](#resources)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# SIGPROF

*Profiling timer expired*

-  sent when CPU time used by the process and by the system on behalf of the process elapses

## Handling Signals

- threads can block handling signals
- signal handlers for specific signals can be registered with signature: `void sigprof_handler(int sig_nr, siginfo_t* info, void *context)`

## Thread-directed Signals

- pthread_kill(2) used to send signal from one thread to another
- `raise()` is equivalent to `pthread_kill(pthread_self(), sig);`

## Timers

- real time’ timer counts down in real (wall clock) time
- virtual time timer counts down in program execution time
- profiling time timer is similar except that it also counts down when the kernel is executing a system call on behalf of the program

## Overhead

- walking the call stack using metadata lookups can be done in well under 100 microseconds
- corresponds to only a 1% slowdown for a 10 millisecond profiling period

## Signal Handler Limitations

- signal handler interrupts normal program execution,
- therefore it is limited in what it can do
-  cannot allocate memory or acquire locks
- therefore stored profile cannot grow dynamically

## Resources

- [build a user level cpu profiler](http://research.swtch.com/pprof)
- [hacking OSX for fun and profiles](http://research.swtch.com/macpprof)
- [summary of linux programming signals](http://www.linuxprogrammingblog.com/all-about-linux-signals?page=show)
- [pthread_kill() man page](http://man7.org/linux/man-pages/man2/pthread_kill.2.html)
- [sigprof and pthreads](https://cschleiden.wordpress.com/2011/09/09/sigprof-signal-handler-and-pthreads/)
- [v8 -sampler.cc](https://github.com/iojs/io.js/blob/v1.x/deps/v8/src/sampler.cc)
- [gperftools source includes ALL profiler components](https://code.google.com/p/gperftools/) *Fast, multi-threaded malloc() and nifty performance analysis tools*
	- profiler works via SIGPROF (see src/profile_handler.h)
	- looks like its using `backtrace` (see src/stacktrace_generic-inl.h)

