// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-kernel open source project
//
// Copyright (c) 2024 Coen ten Thije Boonkkamp and the swift-kernel project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//
public import Kernel_Primitives

#if canImport(Glibc) || canImport(Musl)

    extension Kernel.IOUring {
        /// Opcodes specifying which operation to submit to io_uring.
        ///
        /// Each opcode corresponds to an `IORING_OP_*` constant from `<linux/io_uring.h>`.
        /// When preparing a submission queue entry (SQE), the opcode determines what
        /// the kernel will do when processing that entry.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Prepare a read operation
        /// sqe.opcode = .read
        /// sqe.fd = fd.rawValue
        /// sqe.addr = UInt64(UInt(bitPattern: buffer.baseAddress))
        /// sqe.len = UInt32(buffer.count)
        /// sqe.off = offset
        /// ```
        ///
        /// ## Kernel Version Requirements
        ///
        /// Some opcodes require newer kernel versions:
        /// - `.read`/`.write`: 5.6+
        /// - `.sendZc`: 6.0+
        /// - `.futexWait`/`.futexWake`: 6.7+
        /// - `.ftruncate`: 6.9+
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IOUring``
        /// - ``Kernel/IOUring/Submission``
        public struct Opcode: RawRepresentable, Sendable, Equatable, Hashable {
            public let rawValue: UInt8

            @inlinable
            public init(rawValue: UInt8) {
                self.rawValue = rawValue
            }
        }
    }

    // MARK: - Standard Operations

    extension Kernel.IOUring.Opcode {
        /// No operation (used for wakeup or testing).
        public static let nop = Self(rawValue: 0)

        /// Vectored read (readv).
        public static let readv = Self(rawValue: 1)

        /// Vectored write (writev).
        public static let writev = Self(rawValue: 2)

        /// File sync (fsync).
        public static let fsync = Self(rawValue: 3)

        /// Read from fixed buffers (readv with registered buffers).
        public static let readvFixed = Self(rawValue: 4)

        /// Write to fixed buffers (writev with registered buffers).
        public static let writevFixed = Self(rawValue: 5)

        /// Poll for events on fd.
        public static let pollAdd = Self(rawValue: 6)

        /// Remove existing poll request.
        public static let pollRemove = Self(rawValue: 7)

        /// Sync file data range.
        public static let syncFileRange = Self(rawValue: 8)

        /// Send message on socket.
        public static let sendmsg = Self(rawValue: 9)

        /// Receive message from socket.
        public static let recvmsg = Self(rawValue: 10)

        /// Timeout operation.
        public static let timeout = Self(rawValue: 11)

        /// Remove existing timeout.
        public static let timeoutRemove = Self(rawValue: 12)

        /// Accept connection on socket.
        public static let accept = Self(rawValue: 13)

        /// Cancel in-flight async operation.
        public static let asyncCancel = Self(rawValue: 14)

        /// Link timeout to previous SQE.
        public static let linkTimeout = Self(rawValue: 15)

        /// Connect socket to address.
        public static let connect = Self(rawValue: 16)

        /// Sync file data and metadata to disk.
        public static let fallocate = Self(rawValue: 17)

        /// Open file.
        public static let openat = Self(rawValue: 18)

        /// Close file descriptor.
        public static let close = Self(rawValue: 19)

        /// Update registered files.
        public static let filesUpdate = Self(rawValue: 20)

        /// Get file status.
        public static let statx = Self(rawValue: 21)

        /// Read from file (pread-like, kernel 5.6+).
        public static let read = Self(rawValue: 22)

        /// Write to file (pwrite-like, kernel 5.6+).
        public static let write = Self(rawValue: 23)

        /// Allocate disk space.
        public static let fadvise = Self(rawValue: 24)

        /// Memory advice.
        public static let madvise = Self(rawValue: 25)

        /// Send data on socket.
        public static let send = Self(rawValue: 26)

        /// Receive data from socket.
        public static let recv = Self(rawValue: 27)

        /// Open file relative to directory (openat2).
        public static let openat2 = Self(rawValue: 28)

        /// Add to epoll set.
        public static let epollCtl = Self(rawValue: 29)

        /// Splice data between fds.
        public static let splice = Self(rawValue: 30)

        /// Provide buffers to kernel.
        public static let provideBuffers = Self(rawValue: 31)

        /// Remove provided buffers.
        public static let removeBuffers = Self(rawValue: 32)

        /// Transfer data between fds (tee).
        public static let tee = Self(rawValue: 33)

        /// Shutdown socket.
        public static let shutdown = Self(rawValue: 34)

        /// Rename file.
        public static let renameat = Self(rawValue: 35)

        /// Unlink file.
        public static let unlinkat = Self(rawValue: 36)

        /// Create directory.
        public static let mkdirat = Self(rawValue: 37)

        /// Create symbolic link.
        public static let symlinkat = Self(rawValue: 38)

        /// Create hard link.
        public static let linkat = Self(rawValue: 39)

        /// Send message with zero-copy.
        public static let msgRing = Self(rawValue: 40)

        /// File set xattr.
        public static let fsetxattr = Self(rawValue: 41)

        /// Set xattr.
        public static let setxattr = Self(rawValue: 42)

        /// File get xattr.
        public static let fgetxattr = Self(rawValue: 43)

        /// Get xattr.
        public static let getxattr = Self(rawValue: 44)

        /// Socket operation.
        public static let socket = Self(rawValue: 45)

        /// Uring command.
        public static let uringCmd = Self(rawValue: 46)

        /// Send with zero-copy (kernel 6.0+).
        public static let sendZc = Self(rawValue: 47)

        /// Sendmsg with zero-copy (kernel 6.1+).
        public static let sendmsgZc = Self(rawValue: 48)

        /// Read multishot (kernel 6.2+).
        public static let readMultishot = Self(rawValue: 49)

        /// Wait ID (kernel 6.4+).
        public static let waitid = Self(rawValue: 50)

        /// Futex wait (kernel 6.7+).
        public static let futexWait = Self(rawValue: 51)

        /// Futex wake (kernel 6.7+).
        public static let futexWake = Self(rawValue: 52)

        /// Futex wait v (kernel 6.7+).
        public static let futexWaitv = Self(rawValue: 53)

        /// Fixed fd install (kernel 6.7+).
        public static let fixedFdInstall = Self(rawValue: 54)

        /// Ftruncate (kernel 6.9+).
        public static let ftruncate = Self(rawValue: 55)
    }

    // MARK: - CustomStringConvertible

    extension Kernel.IOUring.Opcode: CustomStringConvertible {
        public var description: String {
            switch self {
            case .nop: return "NOP"
            case .readv: return "READV"
            case .writev: return "WRITEV"
            case .fsync: return "FSYNC"
            case .read: return "READ"
            case .write: return "WRITE"
            case .accept: return "ACCEPT"
            case .connect: return "CONNECT"
            case .send: return "SEND"
            case .recv: return "RECV"
            case .close: return "CLOSE"
            case .asyncCancel: return "ASYNC_CANCEL"
            default: return "OPCODE(\(rawValue))"
            }
        }
    }

#endif
