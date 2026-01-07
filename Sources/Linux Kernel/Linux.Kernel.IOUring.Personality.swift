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
public import Kernel_Primitives

#if canImport(Glibc) || canImport(Musl)

    extension Kernel.IOUring {
        /// Namespace for personality (credential) types.
        ///
        /// Personalities allow io_uring operations to run with different
        /// credentials than the process's default.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IOUring/Personality/ID``
        /// - ``Kernel/IOUring/RegisterOpcode/registerPersonality``
        public enum Personality {}
    }

    // MARK: - Personality.ID

    extension Kernel.IOUring.Personality {
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
        public typealias ID = Tagged<Kernel.IOUring.Personality, UInt16>
    }

    // MARK: - Personality.ID Constants

    extension Tagged where Tag == Kernel.IOUring.Personality, RawValue == UInt16 {
        /// No personality (use process credentials).
        public static var none: Self { Self(0) }
    }

#endif
