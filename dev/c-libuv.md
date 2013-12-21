**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [types](#types)
	- [loop handles](#loop-handles)
		- [`uv_loop_t`](#uv_loop_t)
		- [`uv_handle_t`](#uv_handle_t)
	- [requests](#requests)
		- [`uv_req_t` base for all request types](#uv_req_t-base-for-all-request-types)
		- [`uv_getaddrinfo_t`](#uv_getaddrinfo_t)
		- [`uv_shutdown_t`](#uv_shutdown_t)
		- [`uv_write_t`](#uv_write_t)
		- [`uv_connect_t`](#uv_connect_t)
		- [`uv_udp_send_t`](#uv_udp_send_t)
		- [`uv_fs_t`](#uv_fs_t)
		- [`uv_work_t`](#uv_work_t)
	- [enumerations](#enumerations)
		- [`uv_errno_t`](#uv_errno_t)
		- [`uv_handle_type`](#uv_handle_type)
		- [`uv_req_type`](#uv_req_type)
	- [file info](#file-info)
		- [`uv_stat_t`](#uv_stat_t)
			- [`uv_timespec_t`](#uv_timespec_t)
	- [callbacks](#callbacks)
		- [`uv_alloc_cb`](#uv_alloc_cb)
		- [`uv_read_cb`](#uv_read_cb)
		- [`uv_read2_cb`](#uv_read2_cb)
		- [`uv_write_cb`](#uv_write_cb)
		- [`uv_connect_cb`](#uv_connect_cb)
		- [`uv_shutdown_cb`](#uv_shutdown_cb)
		- [`uv_connection_cb`](#uv_connection_cb)
		- [`uv_close_cb`](#uv_close_cb)
		- [`uv_poll_cb`](#uv_poll_cb)
		- [`uv_timer_cb`](#uv_timer_cb)
		- [`uv_async_cb`](#uv_async_cb)
		- [`uv_prepare_cb`](#uv_prepare_cb)
		- [`uv_check_cb`](#uv_check_cb)
		- [`uv_idle_cb`](#uv_idle_cb)
		- [`uv_exit_cb`](#uv_exit_cb)
		- [`uv_walk_cb`](#uv_walk_cb)
		- [`uv_fs_cb`](#uv_fs_cb)
		- [`uv_work_cb`](#uv_work_cb)
		- [`uv_after_work_cb`](#uv_after_work_cb)
		- [`uv_getaddrinfo_cb`](#uv_getaddrinfo_cb)
		- [`uv_fs_event_cb`](#uv_fs_event_cb)
		- [`uv_fs_poll_cb`](#uv_fs_poll_cb)
		- [`uv_signal_cb`](#uv_signal_cb)
- [methods](#methods)
	- [loop](#loop)
		- [`uv_loop_new`](#uv_loop_new)
		- [`uv_loop_delete`](#uv_loop_delete)
		- [`uv_default_loop`](#uv_default_loop)
		- [`uv_run`](#uv_run)
		- [`uv_loop_alive`](#uv_loop_alive)
		- [`uv_stop`](#uv_stop)
		- [Examples](#examples)
		- [reference count](#reference-count)
		- [used less often](#used-less-often)
			- [time](#time)
				- [`uv_update_time`](#uv_update_time)
			- [backend - embedding loop in another loop](#backend---embedding-loop-in-another-loop)
				- [`uv_backend`](#uv_backend)
	- [file system](#file-system)
	- [errors](#errors)
		- [`uv_strerror`](#uv_strerror)
		- [`uv_err_name`](#uv_err_name)

# types 

## loop handles

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

## requests

### `uv_req_t` base for all request types

```c
/* Abstract base class of all requests. */
struct uv_req_s {

  // UV_REQ_FIELDS
  /* public */
  void* data;

  /* read-only */
  uv_req_type type;

  /* private */
  void* active_queue[2];

  // UV_REQ_PRIVATE_FIELDS (include/uv-unix.h)
  /* empty */
};
```

**Note:** all request types below subclass `uv_req_s` via the inclusion of `UV_REQ_FIELDS`.

### `uv_getaddrinfo_t`

```c
struct uv_getaddrinfo_s {
  /* read-only */
  uv_loop_t* loop;

  // UV_GETADDRINFO_PRIVATE_FIELDS (include/uv-unix.h)
  struct uv__work work_req;
  uv_getaddrinfo_cb cb;
  struct addrinfo* hints;
  char* hostname;
  char* service;
  struct addrinfo* res;
  int retcode;
};
```

### `uv_shutdown_t`

```c
struct uv_shutdown_s {
  uv_stream_t* handle;
  uv_shutdown_cb cb;
  
  // UV_SHUTDOWN_PRIVATE_FIELDS (include/uv-unix.h)
  /* empty */
};
```

### `uv_write_t`

```c
struct uv_write_s {
  uv_write_cb cb;
  uv_stream_t* send_handle;
  uv_stream_t* handle;

  // UV_WRITE_PRIVATE_FIELDS (include/uv-unix.h)
  void* queue[2];
  unsigned int write_index;
  uv_buf_t* bufs;
  unsigned int nbufs;
  int error;
  uv_buf_t bufsml[4];
};
```

### `uv_connect_t`

```c
struct uv_connect_s {
  uv_connect_cb cb;
  uv_stream_t* handle;

  // UV_CONNECT_PRIVATE_FIELDS (include/uv-unix.h)
  void* queue[2];
};
```

### `uv_udp_send_t`

```c
struct uv_udp_send_s {
  uv_udp_t* handle;
  uv_udp_send_cb cb;

  // UV_UDP_SEND_PRIVATE_FIELDS (include/uv-unix.h)
  void* queue[2];
  struct sockaddr_in6 addr;
  unsigned int nbufs;
  uv_buf_t* bufs;
  ssize_t status;
  uv_udp_send_cb send_cb;
  uv_buf_t bufsml[4];
};
```

### `uv_fs_t`

```c
struct uv_fs_s {
  UV_REQ_FIELDS
  uv_fs_type fs_type;
  uv_loop_t* loop;
  uv_fs_cb cb;
  ssize_t result;
  void* ptr;
  const char* path;
  uv_stat_t statbuf;  /* Stores the result of uv_fs_stat and uv_fs_fstat. */

  // UV_FS_PRIVATE_FIELDS (include/uv-unix.h)
  const char *new_path;
  uv_file file;
  int flags;
  mode_t mode;
  void* buf;
  size_t len;
  off_t off;
  uv_uid_t uid;
  uv_gid_t gid;
  double atime;
  double mtime;
  struct uv__work work_req;
};
```

### `uv_work_t`

```c
struct uv_work_s {
  uv_loop_t* loop;
  uv_work_cb work_cb;
  uv_after_work_cb after_work_cb;

  // UV_WORK_PRIVATE_FIELDS (include/uv-unix.h)
  struct uv__work work_req;
};
```

## enumerations

### `uv_errno_t`

```c
typedef enum {

  // UV_ERRNO_MAP(XX)
  XX(E2BIG, "argument list too long")
  XX(EACCES, "permission denied")
  XX(EADDRINUSE, "address already in use")
  XX(EADDRNOTAVAIL, "address not available")
  XX(EAFNOSUPPORT, "address family not supported")
  XX(EAGAIN, "resource temporarily unavailable")
  XX(EAI_ADDRFAMILY, "address family not supported")
  XX(EAI_AGAIN, "temporary failure")
  XX(EAI_BADFLAGS, "bad ai_flags value")
  XX(EAI_BADHINTS, "invalid value for hints")
  XX(EAI_CANCELED, "request canceled")
  XX(EAI_FAIL, "permanent failure")
  XX(EAI_FAMILY, "ai_family not supported")
  XX(EAI_MEMORY, "out of memory")
  XX(EAI_NODATA, "no address")
  XX(EAI_NONAME, "unknown node or service")
  XX(EAI_OVERFLOW, "argument buffer overflow")
  XX(EAI_PROTOCOL, "resolved protocol is unknown")
  XX(EAI_SERVICE, "service not available for socket type")
  XX(EAI_SOCKTYPE, "socket type not supported")
  XX(EAI_SYSTEM, "system error")
  XX(EALREADY, "connection already in progress")
  XX(EBADF, "bad file descriptor")
  XX(EBUSY, "resource busy or locked")
  XX(ECANCELED, "operation canceled")
  XX(ECHARSET, "invalid Unicode character")
  XX(ECONNABORTED, "software caused connection abort")
  XX(ECONNREFUSED, "connection refused")
  XX(ECONNRESET, "connection reset by peer")
  XX(EDESTADDRREQ, "destination address required")
  XX(EEXIST, "file already exists")
  XX(EFAULT, "bad address in system call argument")
  XX(EHOSTUNREACH, "host is unreachable")
  XX(EINTR, "interrupted system call")
  XX(EINVAL, "invalid argument")
  XX(EIO, "i/o error")
  XX(EISCONN, "socket is already connected")
  XX(EISDIR, "illegal operation on a directory")
  XX(ELOOP, "too many symbolic links encountered")
  XX(EMFILE, "too many open files")
  XX(EMSGSIZE, "message too long")
  XX(ENAMETOOLONG, "name too long")
  XX(ENETDOWN, "network is down")
  XX(ENETUNREACH, "network is unreachable")
  XX(ENFILE, "file table overflow")
  XX(ENOBUFS, "no buffer space available")
  XX(ENODEV, "no such device")
  XX(ENOENT, "no such file or directory")
  XX(ENOMEM, "not enough memory")
  XX(ENONET, "machine is not on the network")
  XX(ENOSPC, "no space left on device")
  XX(ENOSYS, "function not implemented")
  XX(ENOTCONN, "socket is not connected")
  XX(ENOTDIR, "not a directory")
  XX(ENOTEMPTY, "directory not empty")
  XX(ENOTSOCK, "socket operation on non-socket")
  XX(ENOTSUP, "operation not supported on socket")
  XX(EPERM, "operation not permitted")
  XX(EPIPE, "broken pipe")
  XX(EPROTO, "protocol error")
  XX(EPROTONOSUPPORT, "protocol not supported")
  XX(EPROTOTYPE, "protocol wrong type for socket")
  XX(EROFS, "read-only file system")
  XX(ESHUTDOWN, "cannot send after transport endpoint shutdown")
  XX(ESPIPE, "invalid seek")
  XX(ESRCH, "no such process")
  XX(ETIMEDOUT, "connection timed out")
  XX(EXDEV, "cross-device link not permitted")
  XX(UNKNOWN, "unknown error")
  XX(EOF, "end of file")

  UV_ERRNO_MAX = UV__EOF - 1
} uv_errno_t;
```

### `uv_handle_type`

```c
typedef enum {
  UV_UNKNOWN_HANDLE = 0,

  // UV_HANDLE_TYPE_MAP(XX) (include/uv.h)
  XX(ASYNC, async)
  XX(CHECK, check)
  XX(FS_EVENT, fs_event)
  XX(FS_POLL, fs_poll)
  XX(HANDLE, handle)
  XX(IDLE, idle)
  XX(NAMED_PIPE, pipe)
  XX(POLL, poll)
  XX(PREPARE, prepare)
  XX(PROCESS, process)
  XX(STREAM, stream)
  XX(TCP, tcp)
  XX(TIMER, timer)
  XX(TTY, tty)
  XX(UDP, udp)
  XX(SIGNAL, signal)
  UV_FILE,

  UV_HANDLE_TYPE_MAX
} uv_handle_type;
```

### `uv_req_type`

```c
typedef enum {
  UV_UNKNOWN_REQ = 0,

  // UV_REQ_TYPE_MAP(XX) (include/uv.h)
  XX(REQ, req)
  XX(CONNECT, connect)
  XX(WRITE, write)
  XX(SHUTDOWN, shutdown)
  XX(UDP_SEND, udp_send)
  XX(FS, fs)
  XX(WORK, work)
  XX(GETADDRINFO, getaddrinfo)

  UV_REQ_TYPE_PRIVATE
  UV_REQ_TYPE_MAX
} uv_req_type;
```

## file info

### `uv_stat_t`

```c
typedef struct {
  uint64_t st_dev;
  uint64_t st_mode;
  uint64_t st_nlink;
  uint64_t st_uid;
  uint64_t st_gid;
  uint64_t st_rdev;
  uint64_t st_ino;
  uint64_t st_size;
  uint64_t st_blksize;
  uint64_t st_blocks;
  uint64_t st_flags;
  uint64_t st_gen;
  uv_timespec_t st_atim;
  uv_timespec_t st_mtim;
  uv_timespec_t st_ctim;
  uv_timespec_t st_birthtim;
};
```

#### `uv_timespec_t`

```c
typedef struct {
  long tv_sec;
  long tv_nsec;
};
```

## callbacks

### `uv_alloc_cb`

```c
/*
 * Should prepare a buffer that libuv can use to read data into.
 *
 * `suggested_size` is a hint. Returning a buffer that is smaller is perfectly
 * okay as long as `buf.len > 0`.
 *
 * If you return a buffer with `buf.len == 0`, libuv skips the read and calls
 * your read or recv callback with nread=UV_ENOBUFS.
 *
 * Note that returning a zero-length buffer does not stop the handle, call
 * uv_read_stop() or uv_udp_recv_stop() for that.
 */
typedef void (*uv_alloc_cb)(uv_handle_t* handle,
                            size_t suggested_size,
                            uv_buf_t* buf);
```

### `uv_read_cb`

```c
/*
 * `nread` is > 0 if there is data available, 0 if libuv is done reading for
 * now, or < 0 on error.
 *
 * The callee is responsible for closing the stream when an error happens.
 * Trying to read from the stream again is undefined.
 *
 * The callee is responsible for freeing the buffer, libuv does not reuse it.
 * The buffer may be a null buffer (where buf->base=NULL and buf->len=0) on
 * EOF or error.
 */
typedef void (*uv_read_cb)(uv_stream_t* stream,
                           ssize_t nread,
                           const uv_buf_t* buf);
```

### `uv_read2_cb`

```c
/*
 * Just like the uv_read_cb except that if the pending parameter is true
 * then you can use uv_accept() to pull the new handle into the process.
 * If no handle is pending then pending will be UV_UNKNOWN_HANDLE.
 */
typedef void (*uv_read2_cb)(uv_pipe_t* pipe,
                                  ssize_t nread,
                                  const uv_buf_t* buf,
                                  uv_handle_type pending);
```

### `uv_write_cb`      

```c
typedef void (*uv_write_cb)(uv_write_t* req, int status);
```

### `uv_connect_cb`    

```c
typedef void (*uv_connect_cb)(uv_connect_t* req, int status);
```

### `uv_shutdown_cb`   

```c
typedef void (*uv_shutdown_cb)(uv_shutdown_t* req, int status);
```

### `uv_connection_cb` 

```c
typedef void (*uv_connection_cb)(uv_stream_t* server, int status);
```

### `uv_close_cb`      

```c
typedef void (*uv_close_cb)(uv_handle_t* handle);
```

### `uv_poll_cb`       

```c
typedef void (*uv_poll_cb)(uv_poll_t* handle, int status, int events);
```

### `uv_timer_cb`      

```c
typedef void (*uv_timer_cb)(uv_timer_t* handle, int status);
```


### `uv_async_cb`      

```c
typedef void (*uv_async_cb)(uv_async_t* handle, int status);
```

### `uv_prepare_cb`    

```c
typedef void (*uv_prepare_cb)(uv_prepare_t* handle,  int status);
```

### `uv_check_cb`      

```c
typedef void (*uv_check_cb)(uv_check_t* handle, int status);
```

### `uv_idle_cb`       

```c
typedef void (*uv_idle_cb)(uv_idle_t* handle, int status);
```

### `uv_exit_cb`       

```c
typedef void (*uv_exit_cb)(uv_process_t*, int64_t exit_status, int term_signal);
```

### `uv_walk_cb`       

```c
typedef void (*uv_walk_cb)(uv_handle_t* handle, void* arg);
```

### `uv_fs_cb`         

```c
typedef void (*uv_fs_cb)(uv_fs_t* req);
```

### `uv_work_cb`       

```c
typedef void (*uv_work_cb)(uv_work_t* req);
```

### `uv_after_work_cb` 

```c
typedef void (*uv_after_work_cb )(uv_work_t* req, int status);
```

### `uv_getaddrinfo_cb`

```c
typedef void (*uv_getaddrinfo_cb)(uv_getaddrinfo_t* req, int status, struct addrinfo* res);
```

### `uv_fs_event_cb`

```c
/*
* This will be called repeatedly after the uv_fs_event_t is initialized.
* If uv_fs_event_t was initialized with a directory the filename parameter
* will be a relative path to a file contained in the directory.
* The events parameter is an ORed mask of enum uv_fs_event elements.
*/
```

```c
typedef void (*uv_fs_event_cb)(uv_fs_event_t* handle, const char* filename,
    int events, int status);
```

### `uv_fs_poll_cb`

```c
typedef void (*uv_fs_poll_cb)(uv_fs_poll_t* handle,
                              int status,
                              const uv_stat_t* prev,
                              const uv_stat_t* curr);
```

### `uv_signal_cb`

```c
typedef void (*uv_signal_cb)(uv_signal_t* handle, int signum);
```

# methods

## loop


### `uv_loop_new`

```c
uv_loop_t* uv_loop_new(void)
```

### `uv_loop_delete`

```c
void uv_loop_delete(uv_loop_t*);
```

### `uv_default_loop`

```c
uv_loop_t* uv_default_loop(void);
```

### `uv_run`

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
```

### `uv_loop_alive`

```c
/*
 * This function checks whether the reference count, the number of active
 * handles or requests left in the event loop, is non-zero.
 */
int uv_loop_alive(const uv_loop_t* loop);
```

### `uv_stop`

```c
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

### used less often

#### time

##### `uv_update_time`

```c
/*
 * Update the event loop's concept of "now". Libuv caches the current time
 * at the start of the event loop tick in order to reduce the number of
 * time-related system calls.
 *
 * You won't normally need to call this function unless you have callbacks
 * that block the event loop for longer periods of time, where "longer" is
 * somewhat subjective but probably on the order of a millisecond or more.
 */
void uv_update_time(uv_loop_t*);

##### `uv_now`

/*
 * Return the current timestamp in milliseconds. The timestamp is cached at
 * the start of the event loop tick, see |uv_update_time()| for details and
 * rationale.
 *
 * The timestamp increases monotonically from some arbitrary point in time.
 * Don't make assumptions about the starting point, you will only get
 * disappointed.
 *
 * Use uv_hrtime() if you need sub-millisecond granularity.
 */
uint64_t uv_now(uv_loop_t*);
```

#### backend - embedding loop in another loop

##### `uv_backend`

```c
/*
 * Get backend file descriptor. Only kqueue, epoll and event ports are
 * supported.
 *
 * This can be used in conjunction with `uv_run(loop, UV_RUN_NOWAIT)` to
 * poll in one thread and run the event loop's event callbacks in another.
 *
 * Useful for embedding libuv's event loop in another event loop.
 * See test/test-embed.c for an example.
 *
 * Note that embedding a kqueue fd in another kqueue pollset doesn't work on
 * all platforms. It's not an error to add the fd but it never generates
 * events.
 */
int uv_backend_fd(const uv_loop_t*);

##### `uv_backend_timeout`

/*
 * Get the poll timeout. The return value is in milliseconds, or -1 for no
 * timeout.
 */
int uv_backend_timeout(const uv_loop_t*);
```

## file system


## errors

Most functions return 0 on success or an error code < 0 on failure.

### `uv_strerror`

```c
/*
 */
const char* uv_strerror(int err);
```

### `uv_err_name`

```
const char* uv_err_name(int err);
```
