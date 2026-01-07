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
        public import Glibc
        public import CLinuxShim
    #elseif canImport(Musl)
        public import Musl
    #endif

    extension Kernel.Event.Poll {
        /// An epoll event describing readiness conditions and associated data.
        ///
        /// Events are used both for registering interest (via `epoll_ctl`) and
        /// receiving notifications (via `epoll_wait`). When registering, you
        /// specify what conditions to monitor; when receiving, you get details
        /// about what happened.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Register interest
        /// let event = Kernel.Event.Poll.Event(
        ///     events: [.in, .et],
        ///     data: .init(connectionId)
        /// )
        /// try Kernel.Event.Poll.control(
        ///     epfd,
        ///     operation: .add,
        ///     descriptor: socketFd,
        ///     event: event
        /// )
        ///
        /// // Process returned events
        /// for event in readyEvents {
        ///     if event.events.contains(.in) {
        ///         // Data available for reading
        ///     }
        /// }
        /// ```
        ///
        /// ## See Also
        ///
        /// - ``Kernel/Event/Poll``
        /// - ``Kernel/Event/Poll/Events``
        /// - ``Kernel/Event/Poll/Data``
        public struct Event: Sendable, Equatable, Hashable {
            /// The event flags that occurred or are being monitored.
            public var events: Events

            /// Data associated with the file descriptor.
            ///
            /// This is typically used to store an identifier that helps dispatch
            /// the event to the appropriate handler.
            public var data: Kernel.Event.Poll.Data

            /// Creates an epoll event.
            ///
            /// - Parameters:
            ///   - events: The event flags to monitor.
            ///   - data: Data to associate with the file descriptor.
            public init(events: Events, data: Kernel.Event.Poll.Data = .zero) {
                self.events = events
                self.data = data
            }
        }
    }

    // MARK: - C Conversion

    extension Kernel.Event.Poll.Event {
        /// Creates an epoll event from the C struct.
        internal init(_ cEvent: epoll_event) {
            self.events = Kernel.Event.Poll.Events(rawValue: cEvent.events)
            self.data = Kernel.Event.Poll.Data(cEvent.data.u64)
        }

        /// Converts to the C epoll_event struct.
        internal var cValue: epoll_event {
            var event = epoll_event()
            event.events = events.rawValue
            event.data.u64 = data.rawValue
            return event
        }
    }

#endif
