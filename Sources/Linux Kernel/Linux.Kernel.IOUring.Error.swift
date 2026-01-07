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
        /// Errors from io_uring operations.
        ///
        /// Low-level errors from io_uring syscalls. Each case wraps the
        /// underlying `Kernel.Error.Code` for platform-specific details.
        /// Convert to `Kernel.Error` for semantic error handling.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// do {
        ///     let ring = try Kernel.IOUring.Setup.setup(entries: 256)
        /// } catch let error as Kernel.IOUring.Error {
        ///     switch error {
        ///     case .setup(let code):
        ///         print("Setup failed: \(code)")
        ///     case .interrupted:
        ///         // Retry the operation
        ///     default:
        ///         print("io_uring error: \(error)")
        ///     }
        /// }
        /// ```
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IOUring``
        /// - ``Kernel/Error``
        /// - ``Kernel/Error/Code``
        public enum Error: Swift.Error, Sendable, Equatable, Hashable {
            /// Failed to create an io_uring instance.
            ///
            /// Common causes: insufficient memory, too many open files,
            /// unsupported kernel version, or invalid parameters.
            case setup(Kernel.Error.Code)

            /// Failed to submit operations or wait for completions.
            ///
            /// Returned by `io_uring_enter`. May indicate queue overflow,
            /// invalid SQE, or system resource exhaustion.
            case enter(Kernel.Error.Code)

            /// Failed to register resources with the ring.
            ///
            /// Returned when registering buffers, files, or other resources.
            /// May indicate invalid parameters or resource limits.
            case register(Kernel.Error.Code)

            /// Operation was interrupted by a signal.
            ///
            /// The operation should typically be retried.
            case interrupted
        }
    }

    extension Kernel.IOUring.Error: CustomStringConvertible {
        public var description: String {
            switch self {
            case .setup(let code):
                return "io_uring_setup failed (\(code))"
            case .enter(let code):
                return "io_uring_enter failed (\(code))"
            case .register(let code):
                return "io_uring_register failed (\(code))"
            case .interrupted:
                return "operation interrupted"
            }
        }
    }

#endif
