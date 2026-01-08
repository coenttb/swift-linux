// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-kernel open source project
//
// Copyright (c) 2024 Coen ten Thije Boonkkamp and the swift-kernel project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//
public import Kernel_Primitives

#if canImport(Glibc) || canImport(Musl)

    extension Kernel.IO.Uring.Mmap {
        /// Mmap offsets for io_uring ring buffers.
        ///
        /// These magic offset values are passed to `mmap()` to map different
        /// parts of the io_uring ring structure:
        ///
        /// - `sqRing`: Maps the submission queue ring (head, tail, mask, flags, array)
        /// - `cqRing`: Maps the completion queue ring (head, tail, mask, cqes)
        /// - `sqes`: Maps the submission queue entry array
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Map the SQ ring
        /// let sqRingPtr = try Kernel.Memory.Map.map(
        ///     length: sqRingSize,
        ///     protection: .readWrite,
        ///     flags: .shared,
        ///     fd: ringFd,
        ///     offset: Kernel.IO.Uring.Mmap.Offset.sqRing
        /// )
        /// ```
        public enum Offset {
            /// Offset for mapping the submission queue ring.
            ///
            /// Value: `IORING_OFF_SQ_RING` (0)
            public static let sqRing: Int64 = 0

            /// Offset for mapping the completion queue ring.
            ///
            /// Value: `IORING_OFF_CQ_RING` (0x8000000)
            public static let cqRing: Int64 = 0x8000000

            /// Offset for mapping the submission queue entries array.
            ///
            /// Value: `IORING_OFF_SQES` (0x10000000)
            public static let sqes: Int64 = 0x1000_0000
        }
    }

#endif
