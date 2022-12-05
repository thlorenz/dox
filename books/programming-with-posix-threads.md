---
file:    Programming with Posix Threads 2.pdf
date:    Wed Nov 30 16:24:47 2022
created with: https://github.com/thlorenz/pdf-annotations-converter
---

# Programming with Posix Threads 2.pdf


## Parallelism

- "parallelism" is the same as English "concurrency" and different from software 
- things proceeding in the same direction independently (without intersection)
- True parallelism can occur only on a multiprocessor system
- concurrency can occur on 
- the illusion of parallelism

## Thread-safe

- can operate 
- mutexes, condition variables, and thread-specific data
- protecting the data rather than 

## reentrant

- thread-safe by 
- change the interface to make a 
- avoid relying on static data
- avoid 
- avoid internal synchronization by saving state in a "context structure"
- controlled by the caller. The caller is then responsible for any necessary synchronizatio

## Execution context

- state of a concurrent entity
- able to continue a context from the point where it 

## Scheduling

- which context (or set of contexts) should execute at any given point 

## Synchronization

- mechanisms for concurrent execution contexts to coordinate 

## run until block

- allow each thread to run until it voluntarily yields the 

## time-slicing

- thread is 
- mutexes and condition variables are used to synchronize the operation of threads
- process includes additional state that is not directly related to "execution context," such as 
- thread is the part of a process that's necessary to execute code
- has a pointer to the thread's current instruction (often called a "PC" or 
- pointer to the top of the thread's stack (SP)
- general registers, and 
- threads do not have their own file descriptors or 
- switch between two threads within a process much faster
- share the address space--code, data, stack

## pthread_detach

- application does not need to know when 

## Nonblocking I/O

- defer issuing an I/O operation until it can complete 

## asynchronous I/O

- can proceed while the program does something else
- Synchronous I/O within multiple threads gives nearly all the advantages of asynchronous I/O
- context 

## Checking for errors

- functions in the Pthreads standard reserve the return value for error status
- errno is 
- include an extra output parameter 
- provides a per-thread errno, which supports other code that uses errno
- use strerror to get a string description of the error 

## pthread_create

- returns an identifier, in the pthread_t value referred 
- get its 

## pthread_equal

- returns a nonzero value if the thread identifiers refer to the same thread
- detach each thread you create when you're finished 
- not detached may retain virtual memory, including 

## pthread_join

- block the caller until the thread you specify has 
- detaches the specified thread automatically

## lifecycle.c

- pass NULL instead of &retval in 
- more than one thread might need to know when some particular 
- wait on a condition variable instead of calling 
- thread would store its return value (or any other information) in 
- broadcast the condition variable to wake all threads

## four basic states

- Ready The thread is able to run, but is waiting for a processor
- Running The thread is currently running
- Blocked The thread is not able to run because it is waiting for something
- Terminated The thread has terminated by returning from its start function

## Startup

- main 
- When the function main returns in 
- terminate the initial 
- call pthread_exit instead of 
- “Thread" stacks may be much 

## Running and blocking

- thread becomes running when it was ready and a processor selects the thread for execution
- some other thread has blocked, or has been preempted by a timeslice
- blocking (or preempted) thread saves its context
- restores the context of the next ready thread 
- thread becomes blocked
- attempts to lock a mutex that is currently locked
- waits on a condition variable
- calls sigwait for a signal that is not currently pending
- attempts an I/O operation that cannot be immediately completed
- for other system operations, such as a page fault

## Termination

- Threads that call pthread_exit or that are cancelled using pthread_cancel
- calling each cleanup handler that the thread registered by calling 
- removed by calling pthread_cleanup_pop
- cancelled thread's return value 
- thread is waiting to join with the terminating thread, that thread is awakened
- returned value 
- pthread_join is a convenience, not a rule
