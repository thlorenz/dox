**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [loop](#loop)
	- [`uv_loop_t`](#uv_loop_t)
- [requests](#requests)
	- [`uv_req_t` base for all request types](#uv_req_t-base-for-all-request-types)
	- [`uv_getaddrinfo_t`](#uv_getaddrinfo_t)
	- [`uv_shutdown_t`](#uv_shutdown_t)
	- [`uv_write_t`](#uv_write_t)
	- [`uv_connect_t`](#uv_connect_t)
	- [`uv_udp_send_t`](#uv_udp_send_t)
	- [`uv_fs_t`](#uv_fs_t)
	- [`uv_work_t`](#uv_work_t)
	- [`uv_connect_t`](#uv_connect_t-1)
- [handles](#handles)
	- [`uv_handle_t`](#uv_handle_t)
	- [streams](#streams)
		- [`uv_stream_t`](#uv_stream_t)
		- [`uv_tcp_t`](#uv_tcp_t)
		- [`uv_tty_t`](#uv_tty_t)
	- [udp](#udp)
		- [`uv_udp_t](#uv_udp_t)
- [file info](#file-info)
	- [`uv_stat_t`](#uv_stat_t)
		- [`uv_timespec_t`](#uv_timespec_t)
- [enumerations](#enumerations)
	- [`uv_errno_t`](#uv_errno_t)
	- [`uv_handle_type`](#uv_handle_type)
	- [`uv_req_type`](#uv_req_type)
	- [`uv_udp_flags`](#uv_udp_flags)

# loop

## `uv_loop_t`

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
# requests

## `uv_req_t` base for all request types

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

## `uv_getaddrinfo_t`

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

## `uv_shutdown_t`

```c
struct uv_shutdown_s {
  uv_stream_t* handle;
  uv_shutdown_cb cb;
  
  // UV_SHUTDOWN_PRIVATE_FIELDS (include/uv-unix.h)
  /* empty */
};
```

## `uv_write_t`

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

## `uv_connect_t`

```c
struct uv_connect_s {
  uv_connect_cb cb;
  uv_stream_t* handle;

  // UV_CONNECT_PRIVATE_FIELDS (include/uv-unix.h)
  void* queue[2];
};
```

## `uv_udp_send_t`

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

## `uv_fs_t`

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

## `uv_work_t`

```c
struct uv_work_s {
  uv_loop_t* loop;
  uv_work_cb work_cb;
  uv_after_work_cb after_work_cb;

  // UV_WORK_PRIVATE_FIELDS (include/uv-unix.h)
  struct uv__work work_req;
};
```

## `uv_connect_t`

```c
struct uv_connect_s {
  uv_connect_cb cb;
  uv_stream_t* handle;

  // UV_CONNECT_PRIVATE_FIELDS (include/uv-unix.h)
  void* queue[2];
};
```

# handles

## `uv_handle_t`

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

**Note:** all handle types (including stream types) subclass `uv_handle_t`.

## streams

### `uv_stream_t`

```c
struct uv_stream_s {

  // UV_STREAM_FIELDS (include/uv.h)
  /* number of bytes queued for writing */
  size_t write_queue_size;
  uv_alloc_cb alloc_cb;
  uv_read_cb read_cb;
  uv_read2_cb read2_cb;
  /* private */

  // UV_STREAM_PRIVATE_FIELDS (include/uv-unix.h)
  uv_connect_t *connect_req;
  uv_shutdown_t *shutdown_req;
  uv__io_t io_watcher;
  void* write_queue[2];
  void* write_completed_queue[2];
  uv_connection_cb connection_cb;
  int delayed_error;
  int accepted_fd;

  // UV_STREAM_PRIVATE_PLATFORM_FIELDS (include/uv-unix.h)
  /* empty */
};
```

**Note:** all stream types subclass `uv_stream_t` and thus `uv_handle_t`.

### `uv_tcp_t`

Represents a TCP stream or TCP server.

```c
struct uv_tcp_s {
  // UV_TCP_PRIVATE_FIELDS (include/uv-unix.h)
  /* empty */
};
```

### `uv_tty_t`

Representing a stream for the console.

```c
struct uv_tty_s {
  // UV_TTY_PRIVATE_FIELDS (include/uv-unix.h)
  struct termios orig_termios;
  int mode;
};
```

## udp

### `uv_udp_t

```c
struct uv_udp_s {
  // UV_UDP_PRIVATE_FIELDS (include/uv-unix.h)
  uv_alloc_cb alloc_cb;
  uv_udp_recv_cb recv_cb;
  uv__io_t io_watcher;
  void* write_queue[2];
  void* write_completed_queue[2];
};
```

# file info

## `uv_stat_t`

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

### `uv_timespec_t`

```c
typedef struct {
  long tv_sec;
  long tv_nsec;
};
```

# enumerations

## `uv_errno_t`

```c
typedef enum {

  // UV_ERRNO_MAP(XX) (include/uv-unix.h)
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

## `uv_handle_type`

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

## `uv_req_type`

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

## `uv_udp_flags`

```c
enum uv_udp_flags {
  /* Disables dual stack mode. */
  UV_UDP_IPV6ONLY = 1,
  /*
   * Indicates message was truncated because read buffer was too small. The
   * remainder was discarded by the OS. Used in uv_udp_recv_cb.
   */
  UV_UDP_PARTIAL = 2
};
```

