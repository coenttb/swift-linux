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

    extension Kernel.IOUring {
        /// Opcodes for registering resources with io_uring.
        ///
        /// Registration allows pre-registering buffers, files, and other
        /// resources with the kernel to avoid per-operation lookup overhead.
        /// This improves performance for frequently-used resources.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Register file descriptors for fast access
        /// var fds: [Int32] = [fd1.rawValue, fd2.rawValue]
        /// try fds.withUnsafeMutableBufferPointer { buffer in
        ///     try Kernel.IOUring.register(
        ///         ring,
        ///         opcode: .registerFiles,
        ///         argument: buffer.baseAddress,
        ///         count: UInt32(buffer.count)
        ///     )
        /// }
        ///
        /// // Use registered fd in SQE (with .fixedFile flag)
        /// sqe.flags = [.fixedFile]
        /// sqe.fd = 0  // Index into registered files, not raw fd
        /// ```
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IOUring``
        /// - ``Kernel/IOUring/Submission/Queue/Entry/Flags``
        public struct RegisterOpcode: RawRepresentable, Sendable, Equatable, Hashable {
            public let rawValue: UInt32

            public init(rawValue: UInt32) {
                self.rawValue = rawValue
            }

            /// Registers buffers for zero-copy I/O.
            ///
            /// Pre-pins buffer memory in the kernel, avoiding per-operation
            /// memory registration overhead.
            ///
            /// - Linux: `IORING_REGISTER_BUFFERS`
            public static let registerBuffers = RegisterOpcode(rawValue: 0)

            /// Unregisters previously registered buffers.
            ///
            /// - Linux: `IORING_UNREGISTER_BUFFERS`
            public static let unregisterBuffers = RegisterOpcode(rawValue: 1)

            /// Registers file descriptors for fast access.
            ///
            /// Allows using fd indices instead of raw descriptors in SQEs
            /// (with `.fixedFile` flag), avoiding fd lookup overhead.
            ///
            /// - Linux: `IORING_REGISTER_FILES`
            public static let registerFiles = RegisterOpcode(rawValue: 2)

            /// Unregisters previously registered files.
            ///
            /// - Linux: `IORING_UNREGISTER_FILES`
            public static let unregisterFiles = RegisterOpcode(rawValue: 3)

            /// Registers an eventfd for completion notifications.
            ///
            /// The eventfd is signaled when completions arrive, allowing
            /// integration with poll-based event loops.
            ///
            /// - Linux: `IORING_REGISTER_EVENTFD`
            public static let registerEventfd = RegisterOpcode(rawValue: 4)

            /// Unregisters the eventfd.
            ///
            /// - Linux: `IORING_UNREGISTER_EVENTFD`
            public static let unregisterEventfd = RegisterOpcode(rawValue: 5)

            /// Updates registered files (add/remove without full re-register).
            ///
            /// - Linux: `IORING_REGISTER_FILES_UPDATE`
            public static let registerFilesUpdate = RegisterOpcode(rawValue: 6)

            /// Registers eventfd for async notification only.
            ///
            /// Only signals eventfd for async completions, not inline ones.
            ///
            /// - Linux: `IORING_REGISTER_EVENTFD_ASYNC`
            public static let registerEventfdAsync = RegisterOpcode(rawValue: 7)

            /// Probes supported operations.
            ///
            /// Returns information about which opcodes are supported by
            /// the running kernel.
            ///
            /// - Linux: `IORING_REGISTER_PROBE`
            public static let registerProbe = RegisterOpcode(rawValue: 8)

            /// Registers a personality (credentials) for operations.
            ///
            /// Allows running operations with different credentials.
            ///
            /// - Linux: `IORING_REGISTER_PERSONALITY`
            public static let registerPersonality = RegisterOpcode(rawValue: 9)

            /// Unregisters a personality.
            ///
            /// - Linux: `IORING_UNREGISTER_PERSONALITY`
            public static let unregisterPersonality = RegisterOpcode(rawValue: 10)

            /// Enables a disabled ring.
            ///
            /// Used after setting up a ring with `.rDisabled` flag.
            ///
            /// - Linux: `IORING_REGISTER_ENABLE_RINGS`
            public static let enableRings = RegisterOpcode(rawValue: 11)
        }
    }

#endif
