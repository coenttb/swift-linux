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

    extension Kernel.IO.Uring {
        /// Namespace for submission queue types.
        ///
        /// Contains types for the submission queue (SQ) side of io_uring,
        /// including queue entries, entry flags, and ring buffer offsets.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IO/Uring/Submission/Queue``
        /// - ``Kernel/IO/Uring/Submission/Queue/Entry``
        /// - ``Kernel/IO/Uring/Completion``
        public enum Submission {}
    }

#endif
