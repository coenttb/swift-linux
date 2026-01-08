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
        /// Namespace for io_uring_enter related types.
        ///
        /// Contains flags for controlling `io_uring_enter` behavior.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IO/Uring/Enter/Flags``
        public enum Enter {}
    }

#endif
