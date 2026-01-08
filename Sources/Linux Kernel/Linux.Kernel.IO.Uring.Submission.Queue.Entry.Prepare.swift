// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-kernel open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-kernel project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//
public import Kernel_Primitives

#if canImport(Glibc) || canImport(Musl)

    #if canImport(Glibc)
        public import Glibc
        public import CLinuxShim
    #elseif canImport(Musl)
        public import Musl
    #endif

    extension Kernel.IO.Uring.Submission.Queue.Entry {
        /// Helper for preparing submission queue entry operations.
        public struct Prepare {
            public var entry: Kernel.IO.Uring.Submission.Queue.Entry

            init(entry: Kernel.IO.Uring.Submission.Queue.Entry) {
                self.entry = entry
            }

            /// Configures this entry for a no-op operation.
            ///
            /// - Parameter data: Operation data to return with completion.
            public mutating func nop(data: Kernel.IO.Uring.Operation.Data) {
                entry.cValue = io_uring_sqe()
                entry.opcode = .nop
                entry.data = data
            }

            /// Configures this entry for a read operation.
            ///
            /// - Parameters:
            ///   - fd: File descriptor to read from.
            ///   - buffer: Buffer pointer to read into.
            ///   - length: Number of bytes to read.
            ///   - offset: File offset (use `.current` for current position).
            ///   - data: Operation data to return with completion.
            public mutating func read(
                fd: Kernel.Descriptor,
                buffer: UnsafeMutableRawPointer,
                length: Kernel.IO.Uring.Length,
                offset: Kernel.IO.Uring.Offset,
                data: Kernel.IO.Uring.Operation.Data
            ) {
                entry.cValue = io_uring_sqe()
                entry.opcode = .read
                entry.fd = fd
                entry.addr = UInt64(UInt(bitPattern: buffer))
                entry.len = length
                entry.offset = offset
                entry.data = data
            }

            /// Configures this entry for a write operation.
            ///
            /// - Parameters:
            ///   - fd: File descriptor to write to.
            ///   - buffer: Buffer pointer containing data to write.
            ///   - length: Number of bytes to write.
            ///   - offset: File offset (use `.current` for current position).
            ///   - data: Operation data to return with completion.
            public mutating func write(
                fd: Kernel.Descriptor,
                buffer: UnsafeRawPointer,
                length: Kernel.IO.Uring.Length,
                offset: Kernel.IO.Uring.Offset,
                data: Kernel.IO.Uring.Operation.Data
            ) {
                entry.cValue = io_uring_sqe()
                entry.opcode = .write
                entry.fd = fd
                entry.addr = UInt64(UInt(bitPattern: buffer))
                entry.len = length
                entry.offset = offset
                entry.data = data
            }

            /// Configures this entry for a cancel operation.
            ///
            /// - Parameters:
            ///   - target: Operation data of the operation to cancel.
            ///   - data: Operation data to return with this cancel's completion.
            public mutating func cancel(
                target: Kernel.IO.Uring.Operation.Data,
                data: Kernel.IO.Uring.Operation.Data
            ) {
                entry.cValue = io_uring_sqe()
                entry.opcode = .asyncCancel
                entry.addr = target.rawValue
                entry.data = data
            }

            /// Configures this entry for an fsync operation.
            ///
            /// - Parameters:
            ///   - fd: File descriptor to sync.
            ///   - datasync: If true, only sync data (not metadata).
            ///   - data: Operation data to return with completion.
            public mutating func fsync(
                fd: Kernel.Descriptor,
                datasync: Bool,
                data: Kernel.IO.Uring.Operation.Data
            ) {
                entry.cValue = io_uring_sqe()
                entry.opcode = .fsync
                entry.fd = fd
                if datasync {
                    entry.opFlags = 1  // IORING_FSYNC_DATASYNC
                }
                entry.data = data
            }

            /// Configures this entry for a close operation.
            ///
            /// - Parameters:
            ///   - fd: File descriptor to close.
            ///   - data: Operation data to return with completion.
            public mutating func close(
                fd: Kernel.Descriptor,
                data: Kernel.IO.Uring.Operation.Data
            ) {
                entry.cValue = io_uring_sqe()
                entry.opcode = .close
                entry.fd = fd
                entry.data = data
            }

            /// Configures this entry for an accept operation.
            ///
            /// - Parameters:
            ///   - fd: Listening socket file descriptor.
            ///   - addr: Optional pointer to sockaddr buffer.
            ///   - addrLen: Optional pointer to sockaddr length.
            ///   - flags: Accept flags.
            ///   - data: Operation data to return with completion.
            public mutating func accept(
                fd: Kernel.Descriptor,
                addr: UnsafeMutableRawPointer?,
                addrLen: UnsafeMutablePointer<UInt32>?,
                flags: Int32,
                data: Kernel.IO.Uring.Operation.Data
            ) {
                entry.cValue = io_uring_sqe()
                entry.opcode = .accept
                entry.fd = fd
                entry.addr = UInt64(UInt(bitPattern: addr))
                entry.offset = Kernel.IO.Uring.Offset(rawValue: UInt64(UInt(bitPattern: addrLen)))
                entry.opFlags = flags
                entry.data = data
            }

            /// Configures this entry for a connect operation.
            ///
            /// - Parameters:
            ///   - fd: Socket file descriptor.
            ///   - addr: Pointer to sockaddr.
            ///   - addrLen: Length of sockaddr.
            ///   - data: Operation data to return with completion.
            public mutating func connect(
                fd: Kernel.Descriptor,
                addr: UnsafeRawPointer,
                addrLen: UInt32,
                data: Kernel.IO.Uring.Operation.Data
            ) {
                entry.cValue = io_uring_sqe()
                entry.opcode = .connect
                entry.fd = fd
                entry.addr = UInt64(UInt(bitPattern: addr))
                entry.offset = Kernel.IO.Uring.Offset(rawValue: UInt64(addrLen))
                entry.data = data
            }

            /// Configures this entry for a send operation.
            ///
            /// - Parameters:
            ///   - fd: Socket file descriptor.
            ///   - buffer: Buffer pointer containing data to send.
            ///   - length: Number of bytes to send.
            ///   - flags: Send flags.
            ///   - data: Operation data to return with completion.
            public mutating func send(
                fd: Kernel.Descriptor,
                buffer: UnsafeRawPointer,
                length: Kernel.IO.Uring.Length,
                flags: Int32,
                data: Kernel.IO.Uring.Operation.Data
            ) {
                entry.cValue = io_uring_sqe()
                entry.opcode = .send
                entry.fd = fd
                entry.addr = UInt64(UInt(bitPattern: buffer))
                entry.len = length
                entry.opFlags = flags
                entry.data = data
            }

            /// Configures this entry for a recv operation.
            ///
            /// - Parameters:
            ///   - fd: Socket file descriptor.
            ///   - buffer: Buffer pointer to receive into.
            ///   - length: Maximum bytes to receive.
            ///   - flags: Recv flags.
            ///   - data: Operation data to return with completion.
            public mutating func recv(
                fd: Kernel.Descriptor,
                buffer: UnsafeMutableRawPointer,
                length: Kernel.IO.Uring.Length,
                flags: Int32,
                data: Kernel.IO.Uring.Operation.Data
            ) {
                entry.cValue = io_uring_sqe()
                entry.opcode = .recv
                entry.fd = fd
                entry.addr = UInt64(UInt(bitPattern: buffer))
                entry.len = length
                entry.opFlags = flags
                entry.data = data
            }
        }
    }

    // MARK: - Prepare Accessor

    extension Kernel.IO.Uring.Submission.Queue.Entry {
        /// Accessor for preparing entry operations.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// var entry = Kernel.IO.Uring.Submission.Queue.Entry()
        /// entry.prepare.read(fd: fd, buffer: buffer, length: len, offset: 0, data: id)
        /// ```
        public var prepare: Prepare {
            get { Prepare(entry: self) }
            set { self = newValue.entry }
        }
    }

#endif
