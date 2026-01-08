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

    extension Kernel.IO.Uring {
        /// Epoll operation opcodes.
        public struct Epoll {
            /// Add to epoll set.
            public static let ctl = Opcode(rawValue: 29)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to epoll operation opcodes.
        public static var epoll: Kernel.IO.Uring.Epoll.Type { Kernel.IO.Uring.Epoll.self }
    }

#endif
