<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [v8 Performance Profiling](#v8-performance-profiling)
  - [Identify and Understand Performance Problem](#identify-and-understand-performance-problem)
  - [Chrome Devtools Profiler](#chrome-devtools-profiler)
  - [Chrome Tracing  ala [`chrome://tracing`](chrome://tracing/)](#chrome-tracing--ala-chrometracingchrometracing)
    - [Tools](#tools)
    - [Resources](#resources)
  - [v8 tools](#v8-tools)
  - [Using Chrome](#using-chrome)
    - [v8 timeline](#v8-timeline)
      - [Capturing](#capturing)
      - [Analyzing](#analyzing)
        - [Top Band](#top-band)
      - [Middle Band](#middle-band)
      - [Bottom Graph](#bottom-graph)
    - [Finding Slow Running Unoptimized Functions](#finding-slow-running-unoptimized-functions)
      - [d8](#d8)
    - [Determining why a Function was not Optimized](#determining-why-a-function-was-not-optimized)
      - [d8](#d8-1)
      - [Improvments](#improvments)
  - [Resources](#resources-1)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# v8 Performance Profiling

## Identify and Understand Performance Problem

[watch](http://youtu.be/UJPdhx5zTaw?t=40m1s) | [slide](http://v8-io12.appspot.com/index.html#83)

- ensure it's JavaScript and not the DOM
- reduce testcase to pure JavaScript and run in `v8` shell
- collect metrics and locate bottlenecks

## Chrome Devtools Profiler

TODO: add info from JS Structure/Sample Profiling talk

## Chrome Tracing  ala [`chrome://tracing`](chrome://tracing/)

### Tools

- [trace-viewer](https://code.google.com/p/trace-viewer/)
- [trace event format](https://docs.google.com/document/d/1CvAClvFfyA5R-PhYUmn5OOQtYMH4h6I0nSsKchNAySU/edit)

### Resources

= [about:tracing](http://dev.chromium.org/developers/how-tos/trace-event-profiling-tool)

TODO: add info from JS Structure/Sample Profiling talk

## v8 tools

- ship with v8 source code
- **plot-time-events**: generates `png` showing v8 timeline
- **(mac|linux|windows)-tick-processor**: generates table of functions sorted by time spent in them


## Using Chrome

### v8 timeline

#### Capturing

[watch](http://youtu.be/VhpdsjBUS3g?t=24m26s)

```sh
Chrome --no-sandbox --js-flags="--prof --noprof-lazy --log-timer-events"

[ .. ]

tools/plot-timer-events /chrome/dir/v8.log
```

#### Analyzing

[watch](http://youtu.be/VhpdsjBUS3g?t=25m00s)

##### Top Band

- `v8.GCScavenger` young generation collection
- `v8.Execute` executing JavaScript
- scavenges interrupt script execution

#### Middle Band

- shows code kind
- bright green - optimized
- blue/purple - unoptimized

#### Bottom Graph

- shows pauses
- lots in beginning since scripts are being parsed
- no pauses when running optimized code
- scavenges (top band) correllate with pause time spikes

### Finding Slow Running Unoptimized Functions

[watch](http://youtu.be/VhpdsjBUS3g?t=27m55s)

```sh
Chrome --no-sandbox --js-flags="--prof --noprof-lazy --log-timer-events"

[ .. ]

tools/mac-timer-events /chrome/dir/v8.log
```

[watch](http://youtu.be/UJPdhx5zTaw?t=42m33s) | [slide](http://v8-io12.appspot.com/index.html#88)

- generates table of functions sorted by time spent in them
- includes C++ functions
- `*` indicates optimized functions
- functions without `*` could not be optimized

#### d8

[watch](http://youtu.be/UJPdhx5zTaw?t=40m53s) | [slide](http://v8-io12.appspot.com/index.html#84)

```sh
/v8/out/native/d8 test.js --prof
```

### Determining why a Function was not Optimized

[watch](http://youtu.be/VhpdsjBUS3g?t=29m00s)
[watch](http://youtu.be/UJPdhx5zTaw?t=39m30s) | [slide](http://v8-io12.appspot.com/index.html#81)

```sh
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --no-sandbox --js-flags="--trace-deopt --trace-opt-verbose --trace-bailout"

[ . lots of other output. ]

[disabled optimization for xxx, reason: The Reason why function couldn't be optimized]
```

- lots of output which is best piped into file and evaluated
- especially watch out for deoptimized functions with lots of arithmetic operations

#### d8

[watch](http://youtu.be/UJPdhx5zTaw?t=35m12s) | [slide](http://v8-io12.appspot.com/index.html#69)

```sh
d8 --trace-opt
```

Log optimizing compiler bailouts:

[watch](http://youtu.be/UJPdhx5zTaw?t=36m24s) | [slide](http://v8-io12.appspot.com/index.html#73)

```sh
d8 --trace-bailout
```

Log deoptimizations:


[watch](http://youtu.be/UJPdhx5zTaw?t=39m12s) | [slide](http://v8-io12.appspot.com/index.html#80)

```sh
d8 --trace-deopt
```

#### Improvments

- don't use construct that caused function to be deoptimized
- or move all code inside construct into separate function and call it instead

## Resources

- [video: accelerating oz with v8](https://www.youtube.com/watch?v=VhpdsjBUS3g) (unable to find slides)
- [video: structural and sampling profiling in google chrome](https://www.youtube.com/watch?v=nxXkquTPng8) |
  [slides](https://www.igvita.com/slides/2012/structural-and-sampling-javascript-profiling-in-chrome.pdf)
- [v8 profiler](https://code.google.com/p/v8/wiki/V8Profiler)
- [stackoverflow: how to debug nodejs applications](http://stackoverflow.com/a/16512303/97443)
