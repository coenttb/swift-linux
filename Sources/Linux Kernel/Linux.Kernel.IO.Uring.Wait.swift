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

    extension Kernel.IO.Uring {
        /// Wait operation opcodes.
        public struct Wait {
            /// Wait ID (kernel 6.4+).
            public static let id = Opcode(rawValue: 50)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to wait operation opcodes.
        public static var wait: Kernel.IO.Uring.Wait.Type { Kernel.IO.Uring.Wait.self }
    }

#endif
