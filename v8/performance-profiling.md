<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [v8 Performance Profiling](#v8-performance-profiling)
  - [Chrome Devtools Profiler](#chrome-devtools-profiler)
  - [Chrome Tracing](#chrome-tracing)
  - [v8 tools](#v8-tools)
  - [Using Chrome](#using-chrome)
    - [v8 timeline](#v8-timeline)
      - [Capturing](#capturing)
      - [Analyzing](#analyzing)
        - [Top Band](#top-band)
      - [Middle Band](#middle-band)
      - [Bottom Graph](#bottom-graph)
    - [Finding Slow Running Unoptimized Functions](#finding-slow-running-unoptimized-functions)
    - [Determining why a Function was not Optimized](#determining-why-a-function-was-not-optimized)
      - [Improvments](#improvments)
  - [Resources](#resources)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# v8 Performance Profiling

## Chrome Devtools Profiler

## Chrome Tracing

- `chrome://tracing`

todo: work through structural profiling talk

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

- generates table of functions sorted by time spent in them
- `*` indicates optimized functions
- functions without `*` could not be optimized

### Determining why a Function was not Optimized

[watch](http://youtu.be/VhpdsjBUS3g?t=29m00s)

```sh
Chrome --no-sandbox --js-flags="--trace-deopt --trace-opt-verbose"

[ . lots of other output. ]

[disabled optimization for xxx, reason: The Reason why function couldn't be optimized]
```

- lots of output which is best piped into file and evaluated
- especially watch out for deoptimized functions with lots of arithmetic operations

#### Improvments

- don't use construct that caused function to be deoptimized
- or move all code inside construct into separate function and call it instead

## Resources

- [video: accelerating oz with v8](https://www.youtube.com/watch?v=VhpdsjBUS3g) (unable to find slides)
- [video: structural and sampling profiling in google chrome](https://www.youtube.com/watch?v=nxXkquTPng8) |
  [slides](https://www.igvita.com/slides/2012/structural-and-sampling-javascript-profiling-in-chrome.pdf)
