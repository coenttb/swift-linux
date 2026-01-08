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
        ///     try Kernel.IO.Uring.register(
        ///         ring,
        ///         opcode: .files.register,
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
        /// - ``Kernel/IO/Uring``
        /// - ``Kernel/IO/Uring/Submission/Queue/Entry/Flags``
        public struct Opcode: RawRepresentable, Sendable, Equatable, Hashable {
            public let rawValue: UInt32

            public init(rawValue: UInt32) {
                self.rawValue = rawValue
            }
        }
    }

#endif
