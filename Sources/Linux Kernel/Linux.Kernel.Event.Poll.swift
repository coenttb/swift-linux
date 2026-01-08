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

    #if canImport(Glibc)
        internal import Glibc
    #elseif canImport(Musl)
        internal import Musl
    #endif

    #if canImport(CLinuxShim)
        internal import CLinuxShim
    #endif

    extension Kernel.Event {
        /// Raw epoll syscall wrappers (Linux only).
        ///
        /// Event.Poll is the scalable I/O event notification mechanism on Linux.
        /// This namespace provides policy-free syscall wrappers.
        ///
        /// Higher layers (swift-io) build registration management,
        /// ID tracking, and event dispatch on top of these primitives.
        public enum Poll {}
    }

    // MARK: - Syscalls

    extension Kernel.Event.Poll {
        /// Creates a new epoll instance.
        ///
        /// - Parameter flags: Flags for the new epoll instance.
        /// - Returns: A file descriptor for the new epoll instance.
        /// - Throws: `Error.create` if creation fails.
        public static func create(flags: Create.Flags = .cloexec) throws(Error) -> Kernel.Descriptor {
            let epfd = epoll_create1(flags.rawValue)
            guard epfd >= 0 else {
                throw .create(.captureErrno())
            }
            return Kernel.Descriptor(rawValue: epfd)
        }

        /// Controls the epoll instance (add/modify/delete).
        ///
        /// - Parameters:
        ///   - epfd: The epoll file descriptor.
        ///   - op: The operation to perform.
        ///   - fd: The target file descriptor.
        ///   - event: The event structure (required for add/modify, ignored for delete).
        /// - Throws: `Error.ctl` if the operation fails.
        public static func ctl(
            _ epfd: Kernel.Descriptor,
            op: Operation,
            fd: Kernel.Descriptor,
            event: Event? = nil
        ) throws(Error) {
            let result: Int32
            if var cEvent = event?.cValue {
                result = epoll_ctl(epfd.rawValue, op.rawValue, fd.rawValue, &cEvent)
            } else {
                result = epoll_ctl(epfd.rawValue, op.rawValue, fd.rawValue, nil)
            }
            guard result == 0 else {
                throw .ctl(.captureErrno())
            }
        }

        /// Waits for events on the epoll instance (internal).
        ///
        /// Low-level wait that writes events into a pre-allocated buffer.
        ///
        /// - Parameters:
        ///   - epfd: The epoll file descriptor.
        ///   - events: Buffer for returned events.
        ///   - timeout: Timeout in milliseconds (-1 for infinite, 0 for immediate).
        /// - Returns: Number of events written to buffer, or 0 on timeout.
        /// - Throws: `Error.wait` on failure, `Error.interrupted` on EINTR.
        internal static func wait(
            _ epfd: Kernel.Descriptor,
            events: inout [Event],
            timeout: Int32
        ) throws(Error) -> Int {
            guard !events.isEmpty else { return 0 }

            // Use stack allocation for small buffers, heap for large ones
            let count = events.count
            let outcome: Result<Int, Error> = withUnsafeTemporaryAllocation(
                of: epoll_event.self,
                capacity: count
            ) { buffer in
                let result = epoll_wait(epfd.rawValue, buffer.baseAddress!, Int32(count), timeout)
                guard result >= 0 else {
                    let code = Kernel.Error.Code.captureErrno()
                    if code.posix == EINTR {
                        return .failure(.interrupted)
                    }
                    return .failure(.wait(code))
                }

                // Convert C events to Swift events
                for i in 0..<Int(result) {
                    events[i] = Event(buffer[i])
                }
                return .success(Int(result))
            }
            return try outcome.get()
        }

        /// Waits for events with a Duration timeout.
        ///
        /// Convenience wrapper that converts Duration to milliseconds.
        ///
        /// - Parameters:
        ///   - epfd: The epoll file descriptor.
        ///   - events: Buffer for returned events.
        ///   - timeout: Timeout duration, or `nil` for infinite.
        /// - Returns: Number of events written to buffer, or 0 on timeout.
        /// - Throws: `Error.wait` on failure, `Error.interrupted` on EINTR.
        public static func wait(
            _ epfd: Kernel.Descriptor,
            events: inout [Event],
            timeout: Duration?
        ) throws(Error) -> Int {
            let ms = Kernel.Time.milliseconds(from: timeout)
            return try wait(epfd, events: &events, timeout: ms)
        }
    }

#endif
