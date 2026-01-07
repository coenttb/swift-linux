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

    extension Kernel.IOUring.Completion {
        /// Namespace for completion queue ring buffer types.
        ///
        /// The completion queue is a ring buffer where the kernel places
        /// results of completed I/O operations (CQEs) for applications to consume.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IOUring/Completion/Queue/Entry``
        /// - ``Kernel/IOUring/Completion/Queue/Offsets``
        public enum Queue {}
    }

#endif
