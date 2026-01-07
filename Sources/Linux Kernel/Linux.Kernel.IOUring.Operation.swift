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

    extension Kernel.IOUring {
        /// Namespace for operation-related types.
        ///
        /// Contains types for associating user data with operations
        /// to correlate submissions with completions.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IOUring/Operation/Data``
        /// - ``Kernel/IOUring/Opcode``
        public enum Operation {}
    }

#endif
