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
        /// Accessor for byte-related properties.
        public var bytes: Bytes { Bytes(entry: self) }

        /// Byte-related properties for completion entry.
        public struct Bytes: Sendable {
            let entry: Kernel.IO.Uring.Completion.Queue.Entry

            init(entry: Kernel.IO.Uring.Completion.Queue.Entry) {
                self.entry = entry
            }

            /// The number of bytes transferred (for read/write operations).
            ///
            /// Returns nil if the operation failed.
            public var transferred: Int? {
                entry.isSuccess ? Int(entry.res) : nil
            }
        }
    }

#endif
