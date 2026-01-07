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

    extension Kernel.IOUring.Completion.Queue {
        /// Swift wrapper for io_uring completion queue entry.
        ///
        /// An Entry contains the result of a completed I/O operation.
        /// This wrapper provides a Swift-native interface to the C `io_uring_cqe` struct.
        ///
        /// ## Usage
        ///
        /// Entries are read from the completion queue ring buffer:
        /// ```swift
        /// let entryPtr = ring.cqes.advanced(by: index)
        /// let entry = Kernel.IOUring.Completion.Queue.Entry(entryPtr.pointee)
        /// if entry.isSuccess {
        ///     print("Completed: \(entry.result) bytes")
        /// }
        /// ```
        ///
        /// ## Thread Safety
        ///
        /// Entries are value types that wrap a C struct. They should be read
        /// on the poll thread from the shared ring buffer.
        public struct Entry: Sendable {
            /// The underlying C struct.
            @usableFromInline
            internal let cValue: io_uring_cqe

            /// Creates an Entry from a C struct.
            @inlinable
            internal init(_ cValue: io_uring_cqe) {
                self.cValue = cValue
            }
        }
    }

    // MARK: - Accessors

    extension Kernel.IOUring.Completion.Queue.Entry {
        /// Operation data from the corresponding submission queue entry.
        ///
        /// This is the value set via `entry.data` when the operation was submitted.
        /// Typically used to recover the operation context (e.g., a pointer to Storage).
        @inlinable
        public var data: Kernel.IOUring.Operation.Data {
            Kernel.IOUring.Operation.Data(cValue.user_data)
        }

        /// Result of the operation.
        ///
        /// - For successful operations: the number of bytes transferred (or other success value)
        /// - For failed operations: a negative errno value
        @inlinable
        public var res: Int32 {
            cValue.res
        }

        /// Entry flags.
        ///
        /// Contains additional information about the completion.
        @inlinable
        public var flags: UInt32 {
            cValue.flags
        }
    }

    // MARK: - Result Interpretation

    extension Kernel.IOUring.Completion.Queue.Entry {
        /// Whether the operation completed successfully.
        @inlinable
        public var isSuccess: Bool {
            res >= 0
        }

        /// Whether the operation failed.
        @inlinable
        public var isError: Bool {
            res < 0
        }

        /// Whether the operation was cancelled.
        ///
        /// Note: ECANCELED = 125 on Linux, hardcoded to avoid @inlinable visibility issues.
        @inlinable
        public var isCancelled: Bool {
            res == -125  // ECANCELED
        }

        /// The error number (for failed operations).
        ///
        /// Returns nil if the operation succeeded.
        @inlinable
        public var errorNumber: Kernel.Error.Number? {
            isError ? Kernel.Error.Number(-res) : nil
        }
    }

    // MARK: - Bytes Accessor

    extension Kernel.IOUring.Completion.Queue.Entry {
        /// Accessor for byte-related properties.
        public var bytes: Bytes { Bytes(entry: self) }

        /// Byte-related properties for completion entry.
        public struct Bytes: Sendable {
            @usableFromInline
            let entry: Kernel.IOUring.Completion.Queue.Entry

            @usableFromInline
            init(entry: Kernel.IOUring.Completion.Queue.Entry) {
                self.entry = entry
            }

            /// The number of bytes transferred (for read/write operations).
            ///
            /// Returns nil if the operation failed.
            @inlinable
            public var transferred: Int? {
                entry.isSuccess ? Int(entry.res) : nil
            }
        }
    }

    // MARK: - Buffer Accessor

    extension Kernel.IOUring.Completion.Queue.Entry {
        /// Accessor for buffer-related properties.
        public var buffer: Buffer { Buffer(entry: self) }

        /// Buffer-related properties for completion entry.
        public struct Buffer: Sendable {
            @usableFromInline
            let entry: Kernel.IOUring.Completion.Queue.Entry

            @usableFromInline
            init(entry: Kernel.IOUring.Completion.Queue.Entry) {
                self.entry = entry
            }

            /// The buffer ID if a buffer was selected.
            ///
            /// Only valid when `.buffer` flag is set.
            @inlinable
            public var id: UInt16? {
                guard Flags(rawValue: entry.flags).contains(.buffer) else { return nil }
                return UInt16(truncatingIfNeeded: entry.flags >> 16)
            }
        }
    }

    // MARK: - Typed Flags Accessors

    extension Kernel.IOUring.Completion.Queue.Entry {
        /// Accessor for typed flag operations.
        public var typed: Typed { Typed(entry: self) }

        /// Typed accessor for flags.
        public struct Typed: Sendable {
            @usableFromInline
            let entry: Kernel.IOUring.Completion.Queue.Entry

            @usableFromInline
            init(entry: Kernel.IOUring.Completion.Queue.Entry) {
                self.entry = entry
            }

            /// The entry flags as a typed value.
            @inlinable
            public var flags: Flags {
                Flags(rawValue: entry.flags)
            }
        }

        /// Whether this entry indicates more completions will follow (multishot).
        @inlinable
        public var hasMore: Bool {
            typed.flags.contains(.more)
        }
    }

#endif
