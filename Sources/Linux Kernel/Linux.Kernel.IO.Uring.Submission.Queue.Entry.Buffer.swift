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
            public var index: Kernel.IO.Uring.Buffer.Index

            /// Buffer group (for buffer selection).
            public var group: Kernel.IO.Uring.Buffer.Group

            init(entry: Kernel.IO.Uring.Submission.Queue.Entry) {
                self.index = Kernel.IO.Uring.Buffer.Index(rawValue: entry.cValue.buf_index)
                self.group = Kernel.IO.Uring.Buffer.Group(rawValue: entry.cValue.buf_group)
            }

            /// Creates a Buffer with the given index and group.
            public init(
                index: Kernel.IO.Uring.Buffer.Index = .init(rawValue: 0),
                group: Kernel.IO.Uring.Buffer.Group = .init(rawValue: 0)
            ) {
                self.index = index
                self.group = group
            }
        }
    }

#endif
