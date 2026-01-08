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
        /// Extended attribute operation opcodes.
        public struct Xattr {
            /// File set xattr.
            public static let fset = Opcode(rawValue: 41)

            /// Set xattr.
            public static let set = Opcode(rawValue: 42)

            /// File get xattr.
            public static let fget = Opcode(rawValue: 43)

            /// Get xattr.
            public static let get = Opcode(rawValue: 44)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to extended attribute operation opcodes.
        public static var xattr: Kernel.IO.Uring.Xattr.Type { Kernel.IO.Uring.Xattr.self }
    }

#endif
