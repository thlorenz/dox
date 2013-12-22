**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [loop](#loop)
	- [`uv_loop_new`](#uv_loop_new)
	- [`uv_loop_delete`](#uv_loop_delete)
	- [`uv_default_loop`](#uv_default_loop)
	- [`uv_run`](#uv_run)
	- [`uv_loop_alive`](#uv_loop_alive)
	- [`uv_stop`](#uv_stop)
	- [Examples](#examples)
	- [reference count](#reference-count)
		- [`uv_ref`](#uv_ref)
		- [`uv_unref`](#uv_unref)
		- [`uv_has_ref`](#uv_has_ref)
	- [time](#time)
		- [`uv_update_time`](#uv_update_time)
	- [backend - embedding loop in another loop](#backend---embedding-loop-in-another-loop)
		- [`uv_backend`](#uv_backend)
- [handles](#handles)
	- [`uv_handle_size`](#uv_handle_size)
	- [`uv_is_active`](#uv_is_active)
	- [`uv_walk`](#uv_walk)
	- [`uv_close`](#uv_close)
- [requests](#requests)
	- [`uv_req_size`](#uv_req_size)
- [buffers](#buffers)
	- [`uv_buf_t `](#uv_buf_t-)
- [streams](#streams)
	- [`uv_listen`](#uv_listen)
	- [`uv_accept`](#uv_accept)
	- [`uv_read_start`](#uv_read_start)
	- [`uv_read_stop`](#uv_read_stop)
	- [`uv_read2_start`](#uv_read2_start)
	- [`uv_write`](#uv_write)
	- [`uv_write2`](#uv_write2)
	- [`uv_try_write`](#uv_try_write)
	- [`uv_is_readable`](#uv_is_readable)
	- [`uv_is_writable`](#uv_is_writable)
	- [`uv_stream_set_blocking`](#uv_stream_set_blocking)
	- [`uv_is_closing`](#uv_is_closing)
- [tcp](#tcp)
	- [`uv_tcp_init`](#uv_tcp_init)
	- [`uv_tcp_open`](#uv_tcp_open)
	- [`uv_tcp_nodelay`](#uv_tcp_nodelay)
	- [`uv_tcp_keepalive`](#uv_tcp_keepalive)
	- [`uv_tcp_simultaneous_accepts`](#uv_tcp_simultaneous_accepts)
	- [`uv_tcp_bind`](#uv_tcp_bind)
	- [`uv_tcp_getsockname`](#uv_tcp_getsockname)
	- [`uv_tcp_getpeername`](#uv_tcp_getpeername)
	- [`uv_tcp_connect`](#uv_tcp_connect)
- [udp](#udp)
	- [`uv_udp_init`](#uv_udp_init)
	- [`uv_udp_open`](#uv_udp_open)
	- [`uv_udp_bind`](#uv_udp_bind)
	- [`uv_udp_getsockname`](#uv_udp_getsockname)
	- [`uv_udp_set_membership`](#uv_udp_set_membership)
	- [`uv_udp_set_multicast_loop`](#uv_udp_set_multicast_loop)
	- [`uv_udp_set_multicast_ttl`](#uv_udp_set_multicast_ttl)
	- [`uv_udp_set_broadcast`](#uv_udp_set_broadcast)
	- [`uv_udp_set_ttl`](#uv_udp_set_ttl)
	- [`uv_udp_send`](#uv_udp_send)
	- [`uv_udp_recv_start`](#uv_udp_recv_start)
	- [`uv_udp_recv_stop`](#uv_udp_recv_stop)
- [tty](#tty)
	- [`uv_tty_init`](#uv_tty_init)
	- [`uv_tty_set_mode`](#uv_tty_set_mode)
	- [`uv_tty_reset_mode`](#uv_tty_reset_mode)
	- [`uv_tty_get_winsize`](#uv_tty_get_winsize)
- [pipe](#pipe)
	- [`uv_pipe_init`](#uv_pipe_init)
	- [`uv_pipe_open`](#uv_pipe_open)
	- [`uv_pipe_bind`](#uv_pipe_bind)
	- [`uv_pipe_connect`](#uv_pipe_connect)
	- [`uv_pipe_pending_instances`](#uv_pipe_pending_instances)
- [files](#files)
	- [`uv_guess_handle`](#uv_guess_handle)
- [errors](#errors)
	- [`uv_strerror`](#uv_strerror)
	- [`uv_err_name`](#uv_err_name)

# loop


## `uv_loop_new`

```c
uv_loop_t* uv_loop_new(void)
```

## `uv_loop_delete`

```c
void uv_loop_delete(uv_loop_t*);
```

## `uv_default_loop`

```c
uv_loop_t* uv_default_loop(void);
```

## `uv_run`

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

## `uv_loop_alive`

```c
/*
 * This function checks whether the reference count, the number of active
 * handles or requests left in the event loop, is non-zero.
 */
int uv_loop_alive(const uv_loop_t* loop);
```

## `uv_stop`

```c
/*
 * This function will stop the event loop by forcing uv_run to end
 * as soon as possible, but not sooner than the next loop iteration.
 * If this function was called before blocking for i/o, the loop won't
 * block for i/o on this iteration.
 */
void uv_stop(uv_loop_t*);
```

## Examples

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

## reference count

### `uv_ref`

```c
/*
 * Manually modify the event loop's reference count. Useful if the user wants
 * to have a handle or timeout that doesn't keep the loop alive.
 */
void uv_ref(uv_handle_t*);
```

### `uv_unref`

```c
void uv_unref(uv_handle_t*);
```

### `uv_has_ref`

```c
int uv_has_ref(const uv_handle_t*);
```

## time

### `uv_update_time`

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

### `uv_now`

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

## backend - embedding loop in another loop

### `uv_backend`

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

### `uv_backend_timeout`

/*
 * Get the poll timeout. The return value is in milliseconds, or -1 for no
 * timeout.
 */
int uv_backend_timeout(const uv_loop_t*);
```

# handles

## `uv_handle_size`

```c
/*
 * Returns size of various handle types, useful for FFI
 * bindings to allocate correct memory without copying struct
 * definitions
 */
size_t uv_handle_size(uv_handle_type type);
```

## `uv_is_active`

```c
/*
 * Returns non-zero if the handle is active, zero if it's inactive.
 *
 * What "active" means depends on the type of handle:
 *
 *  - A uv_async_t handle is always active and cannot be deactivated, except
 *    by closing it with uv_close().
 *
 *  - A uv_pipe_t, uv_tcp_t, uv_udp_t, etc. handle - basically any handle that
 *    deals with I/O - is active when it is doing something that involves I/O,
 *    like reading, writing, connecting, accepting new connections, etc.
 *
 *  - A uv_check_t, uv_idle_t, uv_timer_t, etc. handle is active when it has
 *    been started with a call to uv_check_start(), uv_idle_start(), etc.
 *
 *      Rule of thumb: if a handle of type uv_foo_t has a uv_foo_start()
 *      function, then it's active from the moment that function is called.
 *      Likewise, uv_foo_stop() deactivates the handle again.
 *
 */
int uv_is_active(const uv_handle_t* handle);
```

## `uv_walk`

```c
/*
 * Walk the list of open handles.
 */
void uv_walk(uv_loop_t* loop, uv_walk_cb walk_cb, void* arg);
```

## `uv_close`

```c
/*
 * Request handle to be closed. close_cb will be called asynchronously after
 * this call. This MUST be called on each handle before memory is released.
 *
 * Note that handles that wrap file descriptors are closed immediately but
 * close_cb will still be deferred to the next iteration of the event loop.
 * It gives you a chance to free up any resources associated with the handle.
 *
 * In-progress requests, like uv_connect_t or uv_write_t, are cancelled and
 * have their callbacks called asynchronously with status=UV_ECANCELED.
 */
void uv_close(uv_handle_t* handle, uv_close_cb close_cb);
```

# requests

## `uv_req_size`

```c
/*
 * Returns size of request types, useful for dynamic lookup with FFI
 */
size_t uv_req_size(uv_req_type type);
```

# buffers


## `uv_buf_t `

```c
/*
 * Constructor for uv_buf_t.
 * Due to platform differences the user cannot rely on the ordering of the
 * base and len members of the uv_buf_t struct. The user is responsible for
 * freeing base after the uv_buf_t is done. Return struct passed by value.
 */
UV_EXTERN uv_buf_t uv_buf_init(char* base, unsigned int len);
```

# streams

## `uv_listen`

```c
int uv_listen(uv_stream_t* stream, int backlog, uv_connection_cb cb);
```

## `uv_accept`

```c

/*
 * This call is used in conjunction with uv_listen() to accept incoming
 * connections. Call uv_accept after receiving a uv_connection_cb to accept
 * the connection. Before calling uv_accept use uv_*_init() must be
 * called on the client. Non-zero return value indicates an error.
 *
 * When the uv_connection_cb is called it is guaranteed that uv_accept will
 * complete successfully the first time. If you attempt to use it more than
 * once, it may fail. It is suggested to only call uv_accept once per
 * uv_connection_cb call.
 */

int uv_accept(uv_stream_t* server, uv_stream_t* client);
```

## `uv_read_start`

```c
/*
 * Read data from an incoming stream. The callback will be made several
 * times until there is no more data to read or uv_read_stop is called.
 * When we've reached EOF nread will be set to UV_EOF.
 *
 * When nread < 0, the buf parameter might not point to a valid buffer;
 * in that case buf.len and buf.base are both set to 0.
 *
 * Note that nread might also be 0, which does *not* indicate an error or
 * eof; it happens when libuv requested a buffer through the alloc callback
 * but then decided that it didn't need that buffer.
 */
int uv_read_start(uv_stream_t*, uv_alloc_cb alloc_cb, uv_read_cb read_cb);
```

## `uv_read_stop`

```c
int uv_read_stop(uv_stream_t*);
```

## `uv_read2_start`

```c
/*
 * Extended read methods for receiving handles over a pipe. The pipe must be
 * initialized with ipc == 1.
 */
int uv_read2_start(uv_stream_t*, uv_alloc_cb alloc_cb, uv_read2_cb read_cb);
```

## `uv_write`

```c
/*
 * Write data to stream. Buffers are written in order. Example:
 *
 *   uv_buf_t a[] = {
 *     { .base = "1", .len = 1 },
 *     { .base = "2", .len = 1 }
 *   };
 *
 *   uv_buf_t b[] = {
 *     { .base = "3", .len = 1 },
 *     { .base = "4", .len = 1 }
 *   };
 *
 *   uv_write_t req1;
 *   uv_write_t req2;
 *
 *   // writes "1234"
 *   uv_write(&req1, stream, a, 2);
 *   uv_write(&req2, stream, b, 2);
 *
 */
int uv_write(uv_write_t* req,
             uv_stream_t* handle,
             const uv_buf_t bufs[],
             unsigned int nbufs,
             uv_write_cb cb);
```

## `uv_write2`

```c
/*
 * Extended write function for sending handles over a pipe. The pipe must be
 * initialized with ipc == 1.
 * send_handle must be a TCP socket or pipe, which is a server or a connection
 * (listening or connected state).  Bound sockets or pipes will be assumed to
 * be servers.
 */
int uv_write2(uv_write_t* req,
              uv_stream_t* handle,
              const uv_buf_t bufs[],
              unsigned int nbufs,
              uv_stream_t* send_handle,
              uv_write_cb cb);
```

## `uv_try_write`

```c
/*
 * Same as `uv_write()`, but won't queue write request if it can't be completed
 * immediately.
 * Will return either:
 * - positive number of bytes written
 * - zero - if queued write is needed
 * - negative error code
 */
int uv_try_write(uv_stream_t* handle,
                 const uv_buf_t bufs[],
                 unsigned int nbufs);
```

## `uv_is_readable`

```c
int uv_is_readable(const uv_stream_t* handle);
```

## `uv_is_writable`

```c
int uv_is_writable(const uv_stream_t* handle);
```

## `uv_stream_set_blocking`

```c
/*
 * Enable or disable blocking mode for a stream.
 *
 * When blocking mode is enabled all writes complete synchronously. The
 * interface remains unchanged otherwise, e.g. completion or failure of the
 * operation will still be reported through a callback which is made
 * asychronously.
 *
 * Relying too much on this API is not recommended. It is likely to change
 * significantly in the future.
 *
 * On windows this currently works only for uv_pipe_t instances. On unix it
 * works for tcp, pipe and tty instances. Be aware that changing the blocking
 * mode on unix sets or clears the O_NONBLOCK bit. If you are sharing a handle
 * with another process, the other process is affected by the change too,
 * which can lead to unexpected results.
 *
 * Also libuv currently makes no ordering guarantee when the blocking mode
 * is changed after write requests have already been submitted. Therefore it is
 * recommended to set the blocking mode immediately after opening or creating
 * the stream.
 */
int uv_stream_set_blocking(uv_stream_t* handle, int blocking);
```

## `uv_is_closing`

```c
/*
 * Used to determine whether a stream is closing or closed.
 *
 * N.B. is only valid between the initialization of the handle
 *      and the arrival of the close callback, and cannot be used
 *      to validate the handle.
 */
int uv_is_closing(const uv_handle_t* handle);
```

# tcp

## `uv_tcp_init`

```c
int uv_tcp_init(uv_loop_t*, uv_tcp_t* handle);
```

## `uv_tcp_open`

```c
/*
 * Opens an existing file descriptor or SOCKET as a tcp handle.
 */
int uv_tcp_open(uv_tcp_t* handle, uv_os_sock_t sock);
```

## `uv_tcp_nodelay`

```c
/* Enable/disable Nagle's algorithm. */
int uv_tcp_nodelay(uv_tcp_t* handle, int enable);
```

## `uv_tcp_keepalive`

```c
/*
 * Enable/disable TCP keep-alive.
 *
 * `delay` is the initial delay in seconds, ignored when `enable` is zero.
 */
int uv_tcp_keepalive(uv_tcp_t* handle, int enable, unsigned int delay);
```
## `uv_tcp_simultaneous_accepts`

```c
/*
 * Enable/disable simultaneous asynchronous accept requests that are
 * queued by the operating system when listening for new tcp connections.
 * This setting is used to tune a tcp server for the desired performance.
 * Having simultaneous accepts can significantly improve the rate of
 * accepting connections (which is why it is enabled by default) but
 * may lead to uneven load distribution in multi-process setups.
 */
int uv_tcp_simultaneous_accepts(uv_tcp_t* handle, int enable);
```

## `uv_tcp_bind`

```c
/*
 * Bind the handle to an address and port.  `addr` should point to an
 * initialized struct sockaddr_in or struct sockaddr_in6.
 *
 * When the port is already taken, you can expect to see an UV_EADDRINUSE
 * error from either uv_tcp_bind(), uv_listen() or uv_tcp_connect().
 *
 * That is, a successful call to uv_tcp_bind() does not guarantee that
 * the call to uv_listen() or uv_tcp_connect() will succeed as well.
 */
int uv_tcp_bind(uv_tcp_t* handle, const struct sockaddr* addr);
```

## `uv_tcp_getsockname`

```c
int uv_tcp_getsockname(uv_tcp_t* handle, struct sockaddr* name, int* namelen);
```

## `uv_tcp_getpeername`

```c
int uv_tcp_getpeername(uv_tcp_t* handle, struct sockaddr* name, int* namelen);
```

## `uv_tcp_connect`

```c
/*
 * Establish an IPv4 or IPv6 TCP connection.  Provide an initialized TCP handle
 * and an uninitialized uv_connect_t*.  `addr` should point to an initialized
 * struct sockaddr_in or struct sockaddr_in6.
 *
 * The callback is made when the connection has been established or when a
 * connection error happened.
 */
int uv_tcp_connect(uv_connect_t* req, uv_tcp_t* handle, const struct sockaddr* addr, uv_connect_cb cb);
```

# udp

## `uv_udp_init`

```c
/*
 * Initialize a new UDP handle. The actual socket is created lazily.
 * Returns 0 on success.
 */
int uv_udp_init(uv_loop_t*, uv_udp_t* handle);
```

## `uv_udp_open`

```c
/*
 * Opens an existing file descriptor or SOCKET as a udp handle.
 *
 * Unix only:
 *  The only requirement of the sock argument is that it follows the
 *  datagram contract (works in unconnected mode, supports sendmsg()/recvmsg(),
 *  etc.). In other words, other datagram-type sockets like raw sockets or
 *  netlink sockets can also be passed to this function.
 *
 * This sets the SO_REUSEPORT socket flag on the BSDs and OS X. On other
 * UNIX platforms, it sets the SO_REUSEADDR flag.  What that means is that
 * multiple threads or processes can bind to the same address without error
 * (provided they all set the flag) but only the last one to bind will receive
 * any traffic, in effect "stealing" the port from the previous listener.
 * This behavior is something of an anomaly and may be replaced by an explicit
 * opt-in mechanism in future versions of libuv.
 */
int uv_udp_open(uv_udp_t* handle, uv_os_sock_t sock);
```

## `uv_udp_bind`

```c
/*
 * Bind to a IPv4 address and port.
 *
 * Arguments:
 *  handle    UDP handle. Should have been initialized with `uv_udp_init`.
 *  addr      struct sockaddr_in or struct sockaddr_in6 with the address and
 *            port to bind to.
 *  flags     Unused.
 *
 * Returns:
 *  0 on success, or an error code < 0 on failure.
 *
 * This sets the SO_REUSEPORT socket flag on the BSDs and OS X. On other
 * UNIX platforms, it sets the SO_REUSEADDR flag.  What that means is that
 * multiple threads or processes can bind to the same address without error
 * (provided they all set the flag) but only the last one to bind will receive
 * any traffic, in effect "stealing" the port from the previous listener.
 * This behavior is something of an anomaly and may be replaced by an explicit
 * opt-in mechanism in future versions of libuv.
 */
int uv_udp_bind(uv_udp_t* handle, const struct sockaddr* addr, unsigned int flags);
```

## `uv_udp_getsockname`

```c
int uv_udp_getsockname(uv_udp_t* handle, struct sockaddr* name, int* namelen);
```

## `uv_udp_set_membership`

```c
/*
 * Set membership for a multicast address
 *
 * Arguments:
 *  handle              UDP handle. Should have been initialized with
 *                      `uv_udp_init`.
 *  multicast_addr      multicast address to set membership for
 *  interface_addr      interface address
 *  membership          Should be UV_JOIN_GROUP or UV_LEAVE_GROUP
 *
 * Returns:
 *  0 on success, or an error code < 0 on failure.
 */
int uv_udp_set_membership(uv_udp_t* handle,
                          const char* multicast_addr, 
                          const char* interface_addr,
                          uv_membership membership);
```

## `uv_udp_set_multicast_loop`

```c
/*
 * Set IP multicast loop flag. Makes multicast packets loop back to
 * local sockets.
 *
 * Arguments:
 *  handle              UDP handle. Should have been initialized with
 *                      `uv_udp_init`.
 *  on                  1 for on, 0 for off
 *
 * Returns:
 *  0 on success, or an error code < 0 on failure.
 */
int uv_udp_set_multicast_loop(uv_udp_t* handle, int on);
```

## `uv_udp_set_multicast_ttl`

```c
/*
 * Set the multicast ttl
 *
 * Arguments:
 *  handle              UDP handle. Should have been initialized with
 *                      `uv_udp_init`.
 *  ttl                 1 through 255
 *
 * Returns:
 *  0 on success, or an error code < 0 on failure.
 */
int uv_udp_set_multicast_ttl(uv_udp_t* handle, int ttl);
```

## `uv_udp_set_broadcast`

```c
/*
 * Set broadcast on or off
 *
 * Arguments:
 *  handle              UDP handle. Should have been initialized with
 *                      `uv_udp_init`.
 *  on                  1 for on, 0 for off
 *
 * Returns:
 *  0 on success, or an error code < 0 on failure.
 */
int uv_udp_set_broadcast(uv_udp_t* handle, int on);
```

## `uv_udp_set_ttl`

```c
/*
 * Set the time to live
 *
 * Arguments:
 *  handle              UDP handle. Should have been initialized with
 *                      `uv_udp_init`.
 *  ttl                 1 through 255
 *
 * Returns:
 *  0 on success, or an error code < 0 on failure.
 */
int uv_udp_set_ttl(uv_udp_t* handle, int ttl);
```

## `uv_udp_send`

```c
/*
 * Send data. If the socket has not previously been bound with `uv_udp_bind`
 * or `uv_udp_bind6`, it is bound to 0.0.0.0 (the "all interfaces" address)
 * and a random port number.
 *
 * Arguments:
 *  req       UDP request handle. Need not be initialized.
 *  handle    UDP handle. Should have been initialized with `uv_udp_init`.
 *  bufs      List of buffers to send.
 *  nbufs     Number of buffers in `bufs`.
 *  addr      Address of the remote peer. See `uv_ip4_addr`.
 *  send_cb   Callback to invoke when the data has been sent out.
 *
 * Returns:
 *  0 on success, or an error code < 0 on failure.
 */
int uv_udp_send(uv_udp_send_t* req,
                uv_udp_t* handle,
                const uv_buf_t bufs[],
                unsigned int nbufs,
                const struct sockaddr* addr,
                uv_udp_send_cb send_cb);
```

## `uv_udp_recv_start`

```c
/*
 * Receive data. If the socket has not previously been bound with `uv_udp_bind`
 * or `uv_udp_bind6`, it is bound to 0.0.0.0 (the "all interfaces" address)
 * and a random port number.
 *
 * Arguments:
 *  handle    UDP handle. Should have been initialized with `uv_udp_init`.
 *  alloc_cb  Callback to invoke when temporary storage is needed.
 *  recv_cb   Callback to invoke with received data.
 *
 * Returns:
 *  0 on success, or an error code < 0 on failure.
 */
int uv_udp_recv_start(uv_udp_t* handle, uv_alloc_cb alloc_cb, uv_udp_recv_cb recv_cb);
```

## `uv_udp_recv_stop`

```c
/*
 * Stop listening for incoming datagrams.
 *
 * Arguments:
 *  handle    UDP handle. Should have been initialized with `uv_udp_init`.
 *
 * Returns:
 *  0 on success, or an error code < 0 on failure.
 */
int uv_udp_recv_stop(uv_udp_t* handle);
```

# tty

## `uv_tty_init`

```c
/*
 * Initialize a new TTY stream with the given file descriptor. Usually the
 * file descriptor will be
 *   0 = stdin
 *   1 = stdout
 *   2 = stderr
 * The last argument, readable, specifies if you plan on calling
 * uv_read_start with this stream. stdin is readable, stdout is not.
 *
 * TTY streams which are not readable have blocking writes.
 */
int uv_tty_init(uv_loop_t*, uv_tty_t*, uv_file fd, int readable);
```

## `uv_tty_set_mode`

```c
/*
 * Set mode. 0 for normal, 1 for raw.
 */
int uv_tty_set_mode(uv_tty_t*, int mode);
```

## `uv_tty_reset_mode`

```c
/*
 * To be called when the program exits. Resets TTY settings to default
 * values for the next process to take over.
 *
 * This function is async signal-safe on UNIX platforms but can fail with error
 * code UV_EBUSY if you call it when execution is inside uv_tty_set_mode().
 */
int uv_tty_reset_mode(void);
```

## `uv_tty_get_winsize`

```c
/*
 * Gets the current Window size. On success zero is returned.
 */
int uv_tty_get_winsize(uv_tty_t*, int* width, int* height);
```

# pipe

## `uv_pipe_init`

```c
/*
 * Initialize a pipe. The last argument is a boolean to indicate if
 * this pipe will be used for handle passing between processes.
 */
int uv_pipe_init(uv_loop_t*, uv_pipe_t* handle, int ipc);
```

## `uv_pipe_open`

```c
/*
 * Opens an existing file descriptor or HANDLE as a pipe.
 */
int uv_pipe_open(uv_pipe_t*, uv_file file);
```

## `uv_pipe_bind`

```c
/*
 * Bind the pipe to a file path (UNIX) or a name (Windows.)
 *
 * Paths on UNIX get truncated to `sizeof(sockaddr_un.sun_path)` bytes,
 * typically between 92 and 108 bytes.
 */
int uv_pipe_bind(uv_pipe_t* handle, const char* name);
```

## `uv_pipe_connect`

```c
/*
 * Connect to the UNIX domain socket or the named pipe.
 *
 * Paths on UNIX get truncated to `sizeof(sockaddr_un.sun_path)` bytes,
 * typically between 92 and 108 bytes.
 */
void uv_pipe_connect(uv_connect_t* req, uv_pipe_t* handle, const char* name, uv_connect_cb cb);
```

## `uv_pipe_pending_instances`

```c
/*
 * This setting applies to Windows only.
 * Set the number of pending pipe instance handles when the pipe server
 * is waiting for connections.
 */
void uv_pipe_pending_instances(uv_pipe_t* handle, int count);
```


# files

## `uv_guess_handle`

```c
/*
 * Used to detect what type of stream should be used with a given file
 * descriptor. Usually this will be used during initialization to guess the
 * type of the stdio streams.
 * For isatty() functionality use this function and test for UV_TTY.
 */
uv_handle_type uv_guess_handle(uv_file file);
```


# errors

Most functions return 0 on success or an error code < 0 on failure.

## `uv_strerror`

```c
const char* uv_strerror(int err);
```

## `uv_err_name`

```
const char* uv_err_name(int err);
```
