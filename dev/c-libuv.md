**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [data structures](#data-structures)
	- [loop](#loop)
		- [`uv_loop_t`](#uv_loop_t)
		- [`uv_handle_t`](#uv_handle_t)
- [methods](#methods)
	- [loop](#loop-1)
		- [create/delete/get-default](#createdeleteget-default)
		- [run/alive/stop](#runalivestop)
		- [Examples](#examples)
		- [reference count](#reference-count)

# data structures

## loop

### `uv_loop_t`

```c
/* Public fields */
struct uv_loop_s {
  /* User data - use this for whatever. */
  void* data;
  /* Loop reference counting */
  unsigned int active_handles;
  void* handle_queue[2];
  void* active_reqs[2];
  /* Internal flag to signal loop stop */
  unsigned int stop_flag;

  // UV_LOOP_PRIVATE_FIELDS (include/uv-unix.h)

  unsigned long flags;
  int backend_fd;
  void* pending_queue[2];
  void* watcher_queue[2];
  uv__io_t** watchers;
  unsigned int nwatchers;
  unsigned int nfds;
  void* wq[2];
  uv_mutex_t wq_mutex;
  uv_async_t wq_async;
  uv_handle_t* closing_handles;
  void* process_handles[1][2];
  void* prepare_handles[2];
  void* check_handles[2];
  void* idle_handles[2];
  void* async_handles[2];
  struct uv__async async_watcher;
  /* RB_HEAD(uv__timers, uv_timer_s) */
  struct uv__timers {
    struct uv_timer_s* rbh_root;
  } timer_handles;
  uint64_t time;
  int signal_pipefd[2];
  uv__io_t signal_io_watcher;
  uv_signal_t child_watcher;
  int emfile_fd;
  uint64_t timer_counter;

  // UV_PLATFORM_LOOP_FIELDS (include/uv-darwin.h
  int rcount;
  int wcount;
};
```

### `uv_handle_t`

```c
/* The abstract base class of all handles.  */
struct uv_handle_s {

  // UV_HANDLE_FIELDS (include/uv.h)
  /* public */
  uv_close_cb close_cb;
  void* data;
  /* read-only */
  uv_loop_t* loop;
  uv_handle_type type;
  /* private */
  void* handle_queue[2];

  // UV_HANDLE_PRIVATE_FIELDS (include/uv-unix.h)
  int flags;
  uv_handle_t* next_closing;
};
```

# methods

## loop

### create/delete/get-default

```c
uv_loop_t* uv_loop_new(void)
void uv_loop_delete(uv_loop_t*);
uv_loop_t* uv_default_loop(void);
```

### run/alive/stop 

```c
/*
 * This function runs the event loop. It will act differently depending on the
 * specified mode:
 *  - UV_RUN_DEFAULT: Runs the event loop until the reference count drops to
 *    zero. Always returns zero.
 *  - UV_RUN_ONCE: Poll for new events once. Note that this function blocks if
 *    there are no pending events. Returns zero when done (no active handles
 *    or requests left), or non-zero if more events are expected (meaning you
 *    should run the event loop again sometime in the future).
 *  - UV_RUN_NOWAIT: Poll for new events once but don't block if there are no
 *    pending events.
 */
int uv_run(uv_loop_t*, uv_run_mode mode);

/*
 * This function checks whether the reference count, the number of active
 * handles or requests left in the event loop, is non-zero.
 */
int uv_loop_alive(const uv_loop_t* loop);

/*
 * This function will stop the event loop by forcing uv_run to end
 * as soon as possible, but not sooner than the next loop iteration.
 * If this function was called before blocking for i/o, the loop won't
 * block for i/o on this iteration.
 */
void uv_stop(uv_loop_t*);
```

### Examples

```c
uv_loop_t *loop = uv_loop_new();

printf("Now quitting.\n");
uv_run(loop, UV_RUN_DEFAULT);
```

```c
uv_idle_t idler;

uv_loop_t *loop = uv_default_loop();
uv_idle_init(loop, &idler);
uv_idle_start(&idler, wait_for_a_while);

printf("Idling...\n");
uv_run(loop, UV_RUN_DEFAULT);
```

### reference count

```c
/*
 * Manually modify the event loop's reference count. Useful if the user wants
 * to have a handle or timeout that doesn't keep the loop alive.
 */
void uv_ref(uv_handle_t*);
void uv_unref(uv_handle_t*);
int uv_has_ref(const uv_handle_t*);
```
