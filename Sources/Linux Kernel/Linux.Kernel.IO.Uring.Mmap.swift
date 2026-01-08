// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-linux open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-linux project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

#if canImport(Glibc) || canImport(Musl)
    public import Kernel_Primitives

    extension Kernel.IO.Uring {
        /// Namespace for memory mapping related types.
        ///
        /// Contains offset constants for mapping io_uring ring buffers.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IO/Uring/Mmap/Offset``
        public enum Mmap {}
    }

#endif
