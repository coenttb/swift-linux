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

    #if canImport(Glibc)
        internal import Glibc
    #elseif canImport(Musl)
        internal import Musl
    #endif

    #if canImport(CLinuxShim)
        internal import CLinuxShim
    #endif

    extension Kernel.IO.Uring.Completion.Queue {
        /// Offsets for completion queue ring mapping.
        public struct Offsets: Sendable, Equatable {
            public let head: UInt32
            public let tail: UInt32
            public let ringMask: UInt32
            public let ringEntries: UInt32
            public let overflow: UInt32
            public let cqes: UInt32
            public let flags: UInt32

            internal init() {
                self.head = 0
                self.tail = 0
                self.ringMask = 0
                self.ringEntries = 0
                self.overflow = 0
                self.cqes = 0
                self.flags = 0
            }

            internal init(_ off: io_cqring_offsets) {
                self.head = off.head
                self.tail = off.tail
                self.ringMask = off.ring_mask
                self.ringEntries = off.ring_entries
                self.overflow = off.overflow
                self.cqes = off.cqes
                self.flags = off.flags
            }
        }
    }

#endif
