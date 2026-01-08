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

    extension Kernel.IO.Uring.Register {
        /// Probe registration opcodes.
        public struct Probe {
            /// Probes supported operations.
            ///
            /// Returns information about which opcodes are supported by
            /// the running kernel.
            ///
            /// - Linux: `IORING_REGISTER_PROBE`
            public static let register = Opcode(rawValue: 8)
        }
    }

    extension Kernel.IO.Uring.Register.Opcode {
        /// Access to probe registration opcodes.
        public static var probe: Kernel.IO.Uring.Register.Probe.Type { Kernel.IO.Uring.Register.Probe.self }
    }

#endif
