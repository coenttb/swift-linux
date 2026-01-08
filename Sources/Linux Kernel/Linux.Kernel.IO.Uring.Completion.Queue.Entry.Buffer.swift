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

    extension Kernel.IO.Uring.Completion.Queue.Entry {
        /// Accessor for buffer-related properties.
        public var buffer: Buffer { Buffer(entry: self) }

        /// Buffer-related properties for completion entry.
        public struct Buffer: Sendable {
            let entry: Kernel.IO.Uring.Completion.Queue.Entry

            init(entry: Kernel.IO.Uring.Completion.Queue.Entry) {
                self.entry = entry
            }

            /// The buffer ID if a buffer was selected.
            ///
            /// Only valid when `.buffer` flag is set.
            public var id: UInt16? {
                guard Flags(rawValue: entry.flags).contains(.buffer) else { return nil }
                return UInt16(truncatingIfNeeded: entry.flags >> 16)
            }
        }
    }

#endif
