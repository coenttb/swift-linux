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
        /// Pipe/splice operation opcodes.
        public struct Pipe {
            /// Splice data between fds.
            public static let splice = Opcode(rawValue: 30)

            /// Transfer data between fds (tee).
            public static let tee = Opcode(rawValue: 33)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to pipe/splice operation opcodes.
        public static var pipe: Kernel.IO.Uring.Pipe.Type { Kernel.IO.Uring.Pipe.self }
    }

#endif
