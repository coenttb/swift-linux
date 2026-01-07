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

    extension Kernel.IOUring.Submission.Queue.Entry {
        /// Flags controlling submission queue entry behavior.
        ///
        /// These flags modify how individual SQEs are processed by the kernel,
        /// including linking, buffer selection, and completion behavior.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Link two operations (second runs only if first succeeds)
        /// sqe1.flags = [.ioLink]
        /// sqe2.flags = []  // Will run after sqe1 completes successfully
        ///
        /// // Force async execution
        /// sqe.flags = [.async]
        ///
        /// // Use registered file descriptor
        /// sqe.flags = [.fixedFile]
        /// sqe.fd = registeredIndex  // Index into registered files, not raw fd
        /// ```
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IOUring/Submission/Queue/Entry``
        /// - ``Kernel/IOUring/Opcode``
        public struct Flags: OptionSet, Sendable {
            public let rawValue: UInt8

            public init(rawValue: UInt8) {
                self.rawValue = rawValue
            }

            /// Uses a registered file descriptor instead of a raw fd.
            ///
            /// The `fd` field is interpreted as an index into the registered
            /// file array. Registered files avoid the overhead of looking up
            /// file descriptors on each operation.
            ///
            /// - Linux: `IOSQE_FIXED_FILE`
            public static let fixedFile = Flags(rawValue: 1 << 0)

            /// Links this entry to the next entry in the submission queue.
            ///
            /// The next SQE won't start until this one completes successfully.
            /// If this operation fails, the linked operation is cancelled with
            /// `-ECANCELED`. Use for dependent operations.
            ///
            /// - Linux: `IOSQE_IO_LINK`
            public static let ioLink = Flags(rawValue: 1 << 1)

            /// Links to next entry regardless of success or failure.
            ///
            /// Like `.ioLink`, but the chain continues even if this operation
            /// fails. The linked operation still sees the failure status.
            ///
            /// - Linux: `IOSQE_IO_HARDLINK`
            public static let ioHardlink = Flags(rawValue: 1 << 2)

            /// Forces the operation to execute asynchronously.
            ///
            /// Prevents inline completion even if the operation could complete
            /// immediately. Useful for avoiding blocking the submission path.
            ///
            /// - Linux: `IOSQE_ASYNC`
            public static let async = Flags(rawValue: 1 << 3)

            /// Selects a buffer from the provided buffer pool.
            ///
            /// Instead of providing a fixed buffer, the kernel selects one
            /// from the buffer group specified in `buf_group`. The selected
            /// buffer ID is returned in the CQE.
            ///
            /// - Linux: `IOSQE_BUFFER_SELECT`
            public static let bufferSelect = Flags(rawValue: 1 << 4)

            /// Skips CQE generation on successful completion (kernel 5.17+).
            ///
            /// No completion entry is posted if the operation succeeds.
            /// Failures still generate CQEs. Use to reduce completion overhead
            /// when success confirmation isn't needed.
            ///
            /// - Linux: `IOSQE_CQE_SKIP_SUCCESS`
            public static let cqeSkipSuccess = Flags(rawValue: 1 << 5)
        }
    }

#endif
