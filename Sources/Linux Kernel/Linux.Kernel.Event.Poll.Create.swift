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

#if canImport(Glibc) || canImport(Musl)

    public import Kernel_Primitives

    extension Kernel.Event.Poll {
        /// Namespace for epoll creation types.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/Event/Poll/Create/Flags``
        public enum Create {}
    }

#endif
