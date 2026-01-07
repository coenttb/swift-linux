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

    extension Kernel.IOUring.Submission.Queue {
        /// Swift wrapper for io_uring submission queue entry.
        ///
        /// An Entry describes an I/O operation to be performed by the kernel.
        /// This wrapper provides a Swift-native interface to the C `io_uring_sqe` struct.
        ///
        /// ## Usage
        ///
        /// Entries are typically filled in-place in the submission queue ring buffer:
        /// ```swift
        /// let entryPtr = ring.sqes.advanced(by: index)
        /// var entry = Kernel.IOUring.Submission.Queue.Entry()
        /// entry.setRead(fd: fd, buffer: buffer, offset: 0, data: id)
        /// entryPtr.pointee = entry.cValue
        /// ```
        ///
        /// ## Thread Safety
        ///
        /// Entries are value types that wrap a C struct. They should be filled
        /// on the poll thread and written to the shared ring buffer.
        public struct Entry: Sendable {
            /// The underlying C struct.
            @usableFromInline
            internal var cValue: io_uring_sqe

            /// Creates an empty Entry (zeroed).
            @inlinable
            public init() {
                self.cValue = io_uring_sqe()
            }

            /// Creates an Entry from a C struct.
            @inlinable
            internal init(_ cValue: io_uring_sqe) {
                self.cValue = cValue
            }
        }
    }

    // MARK: - Accessors

    extension Kernel.IOUring.Submission.Queue.Entry {
        /// The operation code.
        @inlinable
        public var opcode: Kernel.IOUring.Opcode {
            get { Kernel.IOUring.Opcode(rawValue: cValue.opcode) }
            set { cValue.opcode = newValue.rawValue }
        }

        /// Entry flags.
        @inlinable
        public var flags: UInt8 {
            get { cValue.flags }
            set { cValue.flags = newValue }
        }

        /// Operation-specific flags (rw_flags field).
        @inlinable
        public var opFlags: Int32 {
            get { cValue.rw_flags }
            set { cValue.rw_flags = newValue }
        }

        /// I/O priority.
        @inlinable
        public var priority: Kernel.IOUring.Priority {
            get { Kernel.IOUring.Priority(rawValue: cValue.ioprio) }
            set { cValue.ioprio = newValue.rawValue }
        }

        /// File descriptor for the operation.
        @inlinable
        public var fd: Kernel.Descriptor {
            get { Kernel.Descriptor(rawValue: cValue.fd) }
            set { cValue.fd = newValue.rawValue }
        }

        /// File offset for read/write operations.
        @inlinable
        public var offset: Kernel.IOUring.Offset {
            get { Kernel.IOUring.Offset(cValue.off) }
            set { cValue.off = newValue.rawValue }
        }

        /// Buffer address or other address field.
        @inlinable
        public var addr: UInt64 {
            get { cValue.addr }
            set { cValue.addr = newValue }
        }

        /// Buffer length.
        @inlinable
        public var len: Kernel.IOUring.Length {
            get { Kernel.IOUring.Length(cValue.len) }
            set { cValue.len = newValue.rawValue }
        }

        /// Operation data returned with completion.
        @inlinable
        public var data: Kernel.IOUring.Operation.Data {
            get { Kernel.IOUring.Operation.Data(cValue.user_data) }
            set { cValue.user_data = newValue.rawValue }
        }

        /// Personality ID (for credentials).
        @inlinable
        public var personality: Kernel.IOUring.Personality.ID {
            get { Kernel.IOUring.Personality.ID(cValue.personality) }
            set { cValue.personality = newValue.rawValue }
        }
    }

    // MARK: - Op Accessor

    extension Kernel.IOUring.Submission.Queue.Entry {
        /// Accessor for operation-specific properties.
        public var op: Op {
            get { Op(entry: self) }
            set { cValue.rw_flags = newValue.flags }
        }

        /// Operation-specific properties for submission entry.
        public struct Op: Sendable {
            /// Operation-specific flags.
            ///
            /// Note: Uses Int32 to match Linux kernel's `__kernel_rwf_t` type.
            public var flags: Int32

            @usableFromInline
            init(entry: Kernel.IOUring.Submission.Queue.Entry) {
                self.flags = entry.cValue.rw_flags
            }

            /// Creates an Op with the given flags.
            public init(flags: Int32) {
                self.flags = flags
            }
        }
    }

    // MARK: - Buffer Accessor

    extension Kernel.IOUring.Submission.Queue.Entry {
        /// Accessor for buffer-related properties.
        public var buffer: Buffer {
            get { Buffer(entry: self) }
            set {
                cValue.buf_index = newValue.index.rawValue
                cValue.buf_group = newValue.group.rawValue
            }
        }

        /// Buffer-related properties for submission entry.
        public struct Buffer: Sendable {
            /// Buffer index (for registered buffers).
            public var index: Kernel.IOUring.Buffer.Index

            /// Buffer group (for buffer selection).
            public var group: Kernel.IOUring.Buffer.Group

            @usableFromInline
            init(entry: Kernel.IOUring.Submission.Queue.Entry) {
                self.index = Kernel.IOUring.Buffer.Index(rawValue: entry.cValue.buf_index)
                self.group = Kernel.IOUring.Buffer.Group(rawValue: entry.cValue.buf_group)
            }

            /// Creates a Buffer with the given index and group.
            public init(
                index: Kernel.IOUring.Buffer.Index = .init(rawValue: 0),
                group: Kernel.IOUring.Buffer.Group = .init(rawValue: 0)
            ) {
                self.index = index
                self.group = group
            }
        }
    }

#endif
