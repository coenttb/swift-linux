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

#if canImport(Glibc) || canImport(Musl)
    public import Kernel_Primitives

    extension Kernel.IO.Uring.Completion.Queue.Entry {
        /// Flags returned with completion queue entries.
        ///
        /// These flags provide additional information about the completed
        /// operation, such as whether a buffer was selected or if more
        /// completions will follow for multishot operations.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// let entry = ...  // CQE from completion queue
        /// if entry.typed.flags.contains(.buffer) {
        ///     let bufferId = entry.buffer.id
        ///     // Use the selected buffer
        /// }
        /// if entry.typed.flags.contains(.more) {
        ///     // More completions coming for this multishot operation
        /// }
        /// ```
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IO/Uring/Completion/Queue/Entry``
        public struct Flags: OptionSet, Sendable {
            public let rawValue: UInt32

            public init(rawValue: UInt32) {
                self.rawValue = rawValue
            }
        }
    }

    extension Kernel.IO.Uring.Completion.Queue.Entry.Flags {
        /// Indicates that a buffer was selected from a buffer group.
        ///
        /// When set, the upper 16 bits of the flags field contain the
        /// buffer ID that was selected. Use `entry.buffer.id` to extract it.
        ///
        /// - Linux: `IORING_CQE_F_BUFFER`
        public static let buffer = Self(rawValue: 1 << 0)

        /// Indicates more completions will follow for this submission.
        ///
        /// Used with multishot operations (e.g., multishot recv) to indicate
        /// that this is not the final completion. The operation remains active.
        ///
        /// - Linux: `IORING_CQE_F_MORE`
        public static let more = Self(rawValue: 1 << 1)

        /// Indicates the socket has more data available.
        ///
        /// Used with recv multishot to signal that more data can be read
        /// immediately without waiting.
        ///
        /// - Linux: `IORING_CQE_F_SOCK_NONEMPTY`
        public static let sockNonempty = Self(rawValue: 1 << 2)

        /// Indicates this is a notification entry, not a completion.
        ///
        /// Used for zero-copy send notifications to indicate when buffers
        /// can be reused.
        ///
        /// - Linux: `IORING_CQE_F_NOTIF`
        public static let notif = Self(rawValue: 1 << 3)
    }

#endif
