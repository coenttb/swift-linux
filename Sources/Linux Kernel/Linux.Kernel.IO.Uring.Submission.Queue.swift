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

    extension Kernel.IO.Uring.Submission {
        /// Namespace for submission queue ring buffer types.
        ///
        /// The submission queue is a ring buffer where applications place
        /// I/O operation requests (SQEs) for the kernel to process.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IO/Uring/Submission/Queue/Entry``
        /// - ``Kernel/IO/Uring/Submission/Queue/Offsets``
        public enum Queue {}
    }

#endif
