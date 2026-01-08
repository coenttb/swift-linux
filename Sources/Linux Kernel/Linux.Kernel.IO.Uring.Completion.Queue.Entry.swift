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

    extension Kernel.IO.Uring.Completion.Queue {
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
        /// let entry = Kernel.IO.Uring.Completion.Queue.Entry(entryPtr.pointee)
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
            internal let cValue: io_uring_cqe

            /// Creates an Entry from a C struct.
            internal init(_ cValue: io_uring_cqe) {
                self.cValue = cValue
            }
        }
    }

    // MARK: - Accessors

    extension Kernel.IO.Uring.Completion.Queue.Entry {
        /// Operation data from the corresponding submission queue entry.
        ///
        /// This is the value set via `entry.data` when the operation was submitted.
        /// Typically used to recover the operation context (e.g., a pointer to Storage).
        public var data: Kernel.IO.Uring.Operation.Data {
            Kernel.IO.Uring.Operation.Data(cValue.user_data)
        }

        /// Result of the operation.
        ///
        /// - For successful operations: the number of bytes transferred (or other success value)
        /// - For failed operations: a negative errno value
        public var res: Int32 {
            cValue.res
        }

        /// Entry flags.
        ///
        /// Contains additional information about the completion.
        public var flags: UInt32 {
            cValue.flags
        }
    }

    // MARK: - Result Interpretation

    extension Kernel.IO.Uring.Completion.Queue.Entry {
        /// Whether the operation completed successfully.
        public var isSuccess: Bool {
            res >= 0
        }

        /// Whether the operation failed.
        public var isError: Bool {
            res < 0
        }

        /// Whether the operation was cancelled.
        ///
        public var isCancelled: Bool {
            res == -125  // ECANCELED
        }

        /// The error number (for failed operations).
        ///
        /// Returns nil if the operation succeeded.
        public var errorNumber: Kernel.Error.Number? {
            isError ? Kernel.Error.Number(-res) : nil
        }
    }

#endif
