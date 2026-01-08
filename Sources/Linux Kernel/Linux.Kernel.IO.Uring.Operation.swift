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

    extension Kernel.IO.Uring {
        /// Namespace for operation-related types.
        ///
        /// Contains types for associating user data with operations
        /// to correlate submissions with completions.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IO/Uring/Operation/Data``
        /// - ``Kernel/IO/Uring/Opcode``
        public enum Operation {}
    }

#endif
