<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Backtrace](#backtrace)
  - [Inside Chromium](#inside-chromium)
  - [Backtrace of Multiple Threads](#backtrace-of-multiple-threads)
- [Related to Backtrace](#related-to-backtrace)
  - [Attaching to a process](#attaching-to-a-process)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Backtrace

- [OSX implementation](http://www.opensource.apple.com/source/Libc/Libc-825.40.1/gen/backtrace.c)
- [Wiki Debugging Techniques](http://en.wikibooks.org/wiki/Linux_Applications_Debugging_Techniques/The_call_stack)
- [function names](http://stackoverflow.com/questions/6934659/how-to-make-backtrace-backtrace-symbols-print-the-function-names)
- [v8 unmangling](https://github.com/iojs/io.js/blob/6bcea4ff932144a5fd02affefd45164fbf471e67/deps/v8/src/base/logging.cc#L39)
- [masscan pixie-backtrace.c](https://github.com/robertdavidgraham/masscan/blob/master/src/pixie-backtrace.c)

### Inside Chromium

- [debug utils](https://code.google.com/p/chromium/codesearch#chromium/src/base/debug/&sq=package:chromium&type=cs)
- [stacktrace-posix](https://code.google.com/p/chromium/codesearch#chromium/src/base/debug/stack_trace_posix.cc)
- [crash_logging.cc](https://code.google.com/p/chromium/codesearch#chromium/src/base/debug/crash_logging.cc)
- [webrtc checks.cc - demangling](https://code.google.com/p/chromium/codesearch#chromium/src/third_party/webrtc/base/checks.cc)
- [logging.cc includes backtrace dumping](https://code.google.com/p/chromium/codesearch#chromium/src/v8/src/base/logging.cc)
- [stacktrace-test.cc with info on how to use stack trace module, problems WRT demangling on OS X, etc.](https://code.google.com/p/chromium/codesearch#chromium/src/base/debug/stack_trace_unittest.cc)
- [gallium u_debug_symbol.c](https://code.google.com/p/chromium/codesearch#chromium/src/third_party/mesa/src/src/gallium/auxiliary/util/u_debug_symbol.c)
- [gallium u_debug_stack.c](https://code.google.com/p/chromium/codesearch#chromium/src/third_party/mesa/src/src/gallium/auxiliary/util/u_debug_stack.c)
- [skia CrashHandler.cpp](https://code.google.com/p/chromium/codesearch#chromium/src/third_party/skia/tools/CrashHandler.cpp)
- [WTF Assertions.cpp includes error handlers printing stack trace](https://code.google.com/p/chromium/codesearch#chromium/src/third_party/WebKit/Source/wtf/Assertions.cpp)
- [arc/backtrace.cc](https://chromium.googlesource.com/arc/arc/+/release-40.4410.184.0/src/common/backtrace.cc)

### Backtrace of Multiple Threads

- [random on github Debug_GetCallStack.cpp](https://github.com/albertz/openlierox/blob/0.59/src/common/Debug_GetCallstack.cpp)
- [stackoverflow answer](http://stackoverflow.com/a/10049967)


## Related to Backtrace

- [GNU Bin Utils addr2line.c](https://github.com/gittup/binutils/blob/gittup/binutils/addr2line.c)
- [adapted version of addr2line](http://cairo.sourcearchive.com/documentation/1.9.2/backtrace-symbols_8c-source.html)
- [linux apl/Backtrace.cc](http://fossies.org/linux/apl/src/Backtrace.cc)
- [backtrace on crash and demangling](http://oroboro.com/stack-trace-on-crash/)

### Attaching to a process

- [how debuggers work](http://eli.thegreenplace.net/2011/01/23/how-debuggers-work-part-1.html)
- [ptrace man page](http://linux.die.net/man/2/ptrace)
- [ptrace source](https://github.com/torvalds/linux/blob/master/kernel/ptrace.c)
