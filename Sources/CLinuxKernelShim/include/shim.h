#ifndef CLINUX_SHIM_H
#define CLINUX_SHIM_H

#if defined(__linux__)

// NOTE: Do NOT define _GNU_SOURCE here - let Glibc handle it
// NOTE: Do NOT include <unistd.h> or <sys/ioctl.h> - already in SwiftGlibc
//       Including them here causes fd_set type conflicts.

// ONLY headers NOT in SwiftGlibc:
#include <sys/epoll.h>       // epoll - NOT in SwiftGlibc
#include <sys/eventfd.h>     // eventfd - NOT in SwiftGlibc
#include <sys/statfs.h>      // statfs - NOT in SwiftGlibc
#include <linux/fs.h>        // FICLONE macro
#include <linux/io_uring.h>  // io_uring structs
#include <sys/syscall.h>     // __NR_* syscall numbers (safe - just defines)

// O_DIRECT - not in SwiftGlibc's fcntl overlay
#ifndef O_DIRECT
#define O_DIRECT 040000
#endif

// FICLONE - ioctl code for reflink cloning
// Value: _IOW(0x94, 9, int) = 0x40049409
#ifndef FICLONE
#define FICLONE 0x40049409
#endif

// Forward declarations of syscall/ioctl - already in glibc, just need signatures.
// These avoid including <unistd.h> and <sys/ioctl.h> which cause fd_set conflicts.
extern long int syscall(long int __sysno, ...) __attribute__((__nothrow__, __leaf__));
extern int ioctl(int __fd, unsigned long int __request, ...) __attribute__((__nothrow__, __leaf__));

// Syscall wrappers - non-variadic functions that Swift can call
// Types match Swift's expectations: off_t = long (Int), size_t = unsigned long (UInt)

#include <stddef.h>      // for size_t
#include <sys/types.h>   // for off_t, ssize_t

static inline ssize_t swift_copy_file_range(
    int fd_in, off_t *off_in,
    int fd_out, off_t *off_out,
    size_t len, unsigned int flags
) {
    return syscall(SYS_copy_file_range, fd_in, off_in, fd_out, off_out, len, flags);
}

static inline int swift_ficlone(int dest_fd, int src_fd) {
    return ioctl(dest_fd, FICLONE, src_fd);
}

static inline int swift_io_uring_setup(unsigned int entries, struct io_uring_params *p) {
    return (int)syscall(SYS_io_uring_setup, entries, p);
}

static inline int swift_io_uring_enter(
    int fd, unsigned int to_submit, unsigned int min_complete,
    unsigned int flags, void *sig, size_t sigsz
) {
    return (int)syscall(SYS_io_uring_enter, fd, to_submit, min_complete, flags, sig, sigsz);
}

static inline int swift_io_uring_register(
    int fd, unsigned int opcode, void *arg, unsigned int nr_args
) {
    return (int)syscall(SYS_io_uring_register, fd, opcode, arg, nr_args);
}

#endif /* __linux__ */

#endif /* CLINUX_SHIM_H */
