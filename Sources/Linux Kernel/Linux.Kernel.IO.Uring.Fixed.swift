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
        /// Fixed fd operation opcodes.
        public struct Fixed {
            /// Fixed fd install (kernel 6.7+).
            public static let fdInstall = Opcode(rawValue: 54)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to fixed fd operation opcodes.
        public static var fixed: Kernel.IO.Uring.Fixed.Type { Kernel.IO.Uring.Fixed.self }
    }

#endif
