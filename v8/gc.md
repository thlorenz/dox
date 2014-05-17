<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [v8 Garbage Collector](#v8-garbage-collector)
  - [Goals, Techniques](#goals-techniques)
  - [Cost of Allocating Memory](#cost-of-allocating-memory)
  - [Collection Steps](#collection-steps)
  - [Two Generations](#two-generations)
  - [Old Generation](#old-generation)
  - [Young Generation](#young-generation)
    - [ToSpace, FromSpace, Memory Exhaustion](#tospace-fromspace-memory-exhaustion)
      - [Sample Scenario](#sample-scenario)
        - [Collection to free ToSpace](#collection-to-free-tospace)
      - [Considerations](#considerations)
  - [Causes For GC Pause](#causes-for-gc-pause)
  - [Resources](#resources)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# v8 Garbage Collector

## Goals, Techniques

- ensures fast object allocation, short garbage collection pauses and no memory fragmentation
- **stop-the-world**, generational accurate garbage collector
- stops program execution when performing garbage collections cycle
- processes only part of the object heap in most garbage collection cycles tom minimize impact of above
- wraps objects in `Handle`s in order to track ovjects in memory even if they get moved (i.e. due to being promoted)

## Cost of Allocating Memory

[watch](http://youtu.be/VhpdsjBUS3g?t=10m54s)

- cheap to allo memory
- expensive to collect when memory pool is exausted

## Collection Steps

[watch](http://youtu.be/VhpdsjBUS3g?t=12m30s)

- parts of collection run concurrent with mutator, i.e. runs on same thread our JavaScript is executed on
- incremental marking
- mark-sweep: return memory to system
- mark-compact:  move values

## Two Generations 

[watch](http://youtu.be/VhpdsjBUS3g?t=11m24s)

- object heap segmented into two parts
- **new space** in which objects are created
- **old space** into which objects that survived a GC cycle are promoted

## Old Generation

- fast alloc
- slow collection performed infrequently
- `~20%` of objects survive into old generation

TODO: gather more old-generation facts

## Young Generation

- fast alloc
- fast collection performed frequently

Most performance problems related to young generation collections.

### ToSpace, FromSpace, Memory Exhaustion

[watch](http://youtu.be/VhpdsjBUS3g?t=13m40s)

- ToSpace is used to alloc values i.e. `new`
- FromSpace used by GC when collection is triggered
- ToSpace and FromSpace have exact same size

#### Sample Scenario

ToSpace starts as unallocated memory.

- alloc A, B, C, D

```
| A | B | C | D | unallocated |
```

- alloc E (not enough space - exhausted YoungGeneration memory)
- triggers collection which blocks the main thread

##### Collection to free ToSpace

- swap labels of FromSpace and ToSpace
- as a result the empty (previous) FromSpace is now the ToSpace
- objects on FromSpace are determined to be live or dead
- dead ones are collected
- live ones are marked and **copied** (expensive) to ToSpace

- assuming B and D were dead

```
| A | C | unallocated        |
```

- now we can allocate E

#### Considerations

[watch](http://youtu.be/VhpdsjBUS3g?t=15m30s)

- every allocation brings us closer to GC pause
- **collection pauses our app**
- try to pre-alloc as much as possible ahead of time

## Causes For GC Pause

[watch](http://youtu.be/VhpdsjBUS3g?t=16m30s)

- calling `new` a lot and keeping references to created objects for longer than necessary
  - client side **never `new` within a frame**

[watch](http://youtu.be/VhpdsjBUS3g?t=17m15s)

- running unoptimized code
  - causes memory allocation for implicit/immediate results of calculations even when not assigned
  - if it was optimized, only for final results gets memory allocated (intermediates stay in registers? -- todo confirm)






  

















## Resources

- [video: accelerating oz with v8](https://www.youtube.com/watch?v=VhpdsjBUS3g) (unable to find slides)
- [v8-design](https://developers.google.com/v8/design#garb_coll)
