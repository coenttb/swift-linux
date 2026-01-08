// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-kernel open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-kernel project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

#if canImport(Glibc) || canImport(Musl)
    public import Kernel_Primitives

    extension Kernel.IO.Uring {
        /// Namespace for personality (credential) types.
        ///
        /// Personalities allow io_uring operations to run with different
        /// credentials than the process's default.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IO/Uring/Personality/ID``
        /// - ``Kernel/IO/Uring/Register.Opcode/registerPersonality``
        public enum Personality {}
    }

    // MARK: - Personality.ID

    extension Kernel.IO.Uring.Personality {
        /// Personality identifier for credential switching.
        ///
        /// Used to execute I/O operations with different credentials than the
        /// process's default. Personalities are registered with `IORING_REGISTER_PERSONALITY`
        /// and referenced in SQEs.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Register a personality (returns ID)
        /// let personality = Personality.ID(registerResult)
        ///
        /// // Use in SQE to run with those credentials
        /// sqe.personality = personality
        /// ```
        public typealias ID = Tagged<Kernel.IO.Uring.Personality, UInt16>
    }

    // MARK: - Personality.ID Constants

    extension Tagged where Tag == Kernel.IO.Uring.Personality, RawValue == UInt16 {
        /// No personality (use process credentials).
        public static var none: Self { Self(0) }
    }

#endif
