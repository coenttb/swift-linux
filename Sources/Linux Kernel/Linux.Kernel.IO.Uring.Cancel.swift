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
        /// Cancel operation opcodes.
        public struct Cancel {
            /// Cancel in-flight async operation.
            public static let async = Opcode(rawValue: 14)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to cancel operation opcodes.
        public static var cancel: Kernel.IO.Uring.Cancel.Type { Kernel.IO.Uring.Cancel.self }
    }

#endif
