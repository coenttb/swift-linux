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
        internal import Glibc
    #elseif canImport(Musl)
        internal import Musl
    #endif

    #if canImport(CLinuxShim)
        internal import CLinuxShim
    #endif

    extension Kernel.IO.Uring.Submission.Queue {
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
        /// var entry = Kernel.IO.Uring.Submission.Queue.Entry()
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
            internal var cValue: io_uring_sqe

            /// Creates an empty Entry (zeroed).
            public init() {
                self.cValue = io_uring_sqe()
            }

            /// Creates an Entry from a C struct.
            internal init(_ cValue: io_uring_sqe) {
                self.cValue = cValue
            }
        }
    }

    // MARK: - Accessors

    extension Kernel.IO.Uring.Submission.Queue.Entry {
        /// The operation code.
        public var opcode: Kernel.IO.Uring.Opcode {
            get { Kernel.IO.Uring.Opcode(rawValue: cValue.opcode) }
            set { cValue.opcode = newValue.rawValue }
        }

        /// Entry flags.
        public var flags: UInt8 {
            get { cValue.flags }
            set { cValue.flags = newValue }
        }

        /// Operation-specific flags (rw_flags field).
        public var opFlags: Int32 {
            get { cValue.rw_flags }
            set { cValue.rw_flags = newValue }
        }

        /// I/O priority.
        public var priority: Kernel.IO.Uring.Priority {
            get { Kernel.IO.Uring.Priority(rawValue: cValue.ioprio) }
            set { cValue.ioprio = newValue.rawValue }
        }

        /// File descriptor for the operation.
        public var fd: Kernel.Descriptor {
            get { Kernel.Descriptor(rawValue: cValue.fd) }
            set { cValue.fd = newValue.rawValue }
        }

        /// File offset for read/write operations.
        public var offset: Kernel.IO.Uring.Offset {
            get { Kernel.IO.Uring.Offset(cValue.off) }
            set { cValue.off = newValue.rawValue }
        }

        /// Buffer address or other address field.
        public var addr: UInt64 {
            get { cValue.addr }
            set { cValue.addr = newValue }
        }

        /// Buffer length.
        public var len: Kernel.IO.Uring.Length {
            get { Kernel.IO.Uring.Length(cValue.len) }
            set { cValue.len = newValue.rawValue }
        }

        /// Operation data returned with completion.
        public var data: Kernel.IO.Uring.Operation.Data {
            get { Kernel.IO.Uring.Operation.Data(cValue.user_data) }
            set { cValue.user_data = newValue.rawValue }
        }

        /// Personality ID (for credentials).
        public var personality: Kernel.IO.Uring.Personality.ID {
            get { Kernel.IO.Uring.Personality.ID(cValue.personality) }
            set { cValue.personality = newValue.rawValue }
        }
    }

#endif
