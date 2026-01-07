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

    extension Kernel.IOUring {
        /// Namespace for io_uring setup and configuration types.
        ///
        /// Contains types used when creating an io_uring instance,
        /// including setup flags and configuration parameters.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IOUring/Setup/Flags``
        /// - ``Kernel/IOUring/Params``
        public enum Setup {}
    }

#endif
