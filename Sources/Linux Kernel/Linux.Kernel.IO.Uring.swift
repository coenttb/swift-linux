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

    extension Kernel.IO {
        /// Raw io_uring syscall wrappers (Linux only).
        ///
        /// io_uring is a high-performance asynchronous I/O interface for Linux (kernel 5.1+).
        /// This namespace provides policy-free syscall wrappers.
        ///
        /// Higher layers (swift-io) build ring memory management, SQ/CQ indexing,
        /// and operation dispatch on top of these primitives.
        public enum Uring {}
    }

    extension Kernel.IO.Uring {
        /// Phantom type tag for the io_uring byte space.
        ///
        /// Used to parameterize Dimension types for io_uring operations.
        /// IO.Uring uses UInt64 for offsets (with UInt64.max meaning "current position").
        public enum Space {}
    }

#endif

#if canImport(Glibc) || canImport(Musl)

    #if canImport(Glibc)
        internal import Glibc
    #elseif canImport(Musl)
        internal import Musl
    #endif

    #if canImport(CLinuxShim)
        internal import CLinuxShim
    #endif

    extension Kernel.IO.Uring {
        /// Creates a new io_uring instance.
        ///
        /// - Parameters:
        ///   - entries: Number of SQ entries (rounded up to power of 2).
        ///   - params: Parameters struct (modified on return with ring offsets).
        /// - Returns: File descriptor for the io_uring instance.
        /// - Throws: `Error.setup` if creation fails.
        ///
        /// ## Blocking Behavior
        ///
        /// This method performs a blocking syscall. Call from a blocking context
        /// (dedicated thread pool), not the Swift cooperative thread pool.
        ///
        /// ## Cancellation
        ///
        /// Not cancellable once the syscall begins. Check task cancellation
        /// before calling if cooperative cancellation is needed.
        public static func setup(
            entries: UInt32,
            params: inout Params
        ) throws(Error) -> Kernel.Descriptor {
            var cParams = params.cValue
            let fd = swift_io_uring_setup(entries, &cParams)
            guard fd >= 0 else {
                throw .setup(.captureErrno())
            }
            // Update params with kernel-filled values
            params = Params(cParams)
            return Kernel.Descriptor(rawValue: fd)
        }

        /// Submits operations and/or waits for completions.
        ///
        /// - Parameters:
        ///   - fd: io_uring file descriptor.
        ///   - toSubmit: Number of SQEs to submit.
        ///   - minComplete: Minimum completions to wait for.
        ///   - flags: Enter flags.
        /// - Returns: Number of SQEs submitted.
        /// - Throws: `Error.enter` on failure, `Error.interrupted` on EINTR.
        ///
        /// ## Blocking Behavior
        ///
        /// May block if `minComplete > 0` or if `.getEvents` flag is set.
        /// Call from a blocking context (dedicated thread pool), not the
        /// Swift cooperative thread pool.
        ///
        /// ## Cancellation
        ///
        /// If interrupted by a signal, throws `Error.interrupted`. Callers
        /// should typically retry on interruption unless cancellation is desired.
        public static func enter(
            _ fd: Kernel.Descriptor,
            toSubmit: UInt32,
            minComplete: UInt32,
            flags: Enter.Flags
        ) throws(Error) -> Int {
            let result = swift_io_uring_enter(
                fd.rawValue,
                toSubmit,
                minComplete,
                flags.rawValue,
                nil,
                0
            )
            guard result >= 0 else {
                let code = Kernel.Error.Code.captureErrno()
                if code.posix == EINTR { throw .interrupted }
                throw .enter(code)
            }
            return Int(result)
        }

        /// Registers resources with the io_uring instance.
        ///
        /// - Parameters:
        ///   - fd: io_uring file descriptor.
        ///   - opcode: The registration operation to perform.
        ///   - argument: Pointer to the arguments for the operation.
        ///   - count: Number of arguments.
        /// - Throws: `Error.register` on failure.
        ///
        /// ## Blocking Behavior
        ///
        /// This method performs a blocking syscall. Call from a blocking context
        /// (dedicated thread pool), not the Swift cooperative thread pool.
        ///
        /// ## Cancellation
        ///
        /// Not cancellable once the syscall begins. Check task cancellation
        /// before calling if cooperative cancellation is needed.
        public static func register(
            _ fd: Kernel.Descriptor,
            opcode: Register.Opcode,
            argument: UnsafeMutableRawPointer?,
            count: UInt32
        ) throws(Error) {
            let result = swift_io_uring_register(
                fd.rawValue,
                opcode.rawValue,
                argument,
                count
            )
            guard result >= 0 else {
                throw .register(.captureErrno())
            }
        }

        /// Closes an io_uring instance.
        ///
        /// Uses `Kernel.Close.close()` for consistency. Ignores errors.
        ///
        /// - Parameter fd: The io_uring file descriptor to close.
        ///
        /// ## Blocking Behavior
        ///
        /// This method performs a blocking syscall but typically completes quickly.
        ///
        /// ## Shutdown
        ///
        /// Closing the ring immediately invalidates all pending submissions and
        /// completions. Ensure all in-flight operations are completed or cancelled
        /// before closing.
        public static func close(_ fd: Kernel.Descriptor) {
            try? Kernel.Close.close(fd)
        }
    }

    // MARK: - Runtime Detection

    extension Kernel.IO.Uring {
        /// Whether io_uring is available on this system.
        ///
        /// Checks by attempting `io_uring_setup` with minimal parameters.
        /// Result is cached after first call.
        ///
        /// Can be disabled via the `IO_URING_DISABLED=1` environment variable.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// if Kernel.IO.Uring.isSupported {
        ///     // Use io_uring backend
        /// } else {
        ///     // Fall back to epoll or other backend
        /// }
        /// ```
        public static var isSupported: Bool {
            _isSupported
        }

        /// Cached support check.
        private static let _isSupported: Bool = {
            // Check if disabled via environment
            if Kernel.Environment.isSet("IO_URING_DISABLED", to: "1") {
                return false
            }

            // Try to set up a minimal ring to check support
            var params = Params()
            do {
                let fd = try setup(entries: 1, params: &params)
                close(fd)
                return true
            } catch {
                return false
            }
        }()
    }

#endif
