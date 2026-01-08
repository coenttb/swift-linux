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

    extension Kernel.IO.Uring.Register {
        /// Eventfd registration opcodes.
        public struct Eventfd {
            /// Registers an eventfd for completion notifications.
            ///
            /// The eventfd is signaled when completions arrive, allowing
            /// integration with poll-based event loops.
            ///
            /// - Linux: `IORING_REGISTER_EVENTFD`
            public static let register = Opcode(rawValue: 4)

            /// Unregisters the eventfd.
            ///
            /// - Linux: `IORING_UNREGISTER_EVENTFD`
            public static let unregister = Opcode(rawValue: 5)

            /// Registers eventfd for async notification only.
            ///
            /// Only signals eventfd for async completions, not inline ones.
            ///
            /// - Linux: `IORING_REGISTER_EVENTFD_ASYNC`
            public static let async = Opcode(rawValue: 7)
        }
    }

    extension Kernel.IO.Uring.Register.Opcode {
        /// Access to eventfd registration opcodes.
        public static var eventfd: Kernel.IO.Uring.Register.Eventfd.Type { Kernel.IO.Uring.Register.Eventfd.self }
    }

#endif
