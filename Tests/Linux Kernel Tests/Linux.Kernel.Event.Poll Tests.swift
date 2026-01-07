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

#if os(Linux)
    #if canImport(Glibc)
        import Glibc
    #elseif canImport(Musl)
        import Musl
    #endif
    import StandardsTestSupport
    import Testing

    import Kernel_Primitives
    @testable import Linux_Kernel

    import Kernel_Primitives_Test_Support

    extension Kernel.Event.Poll {
        #TestSuites
    }

    // MARK: - Syscall Unit Tests

    extension Kernel.Event.Poll.Test.Unit {

        // MARK: - Lifecycle Tests

        @Test("create returns valid epoll descriptor")
        func createReturnsValidDescriptor() throws {
            let epfd = try Kernel.Event.Poll.create(flags: .cloexec)
            defer { Kernel.Event.Test.closeNoThrow(epfd) }

            #expect(epfd.rawValue >= 0)
        }

        // MARK: - Control Tests

        @Test("ctl add registers read interest on pipe")
        func ctlAddRegistersReadInterest() throws {
            let (readFd, writeFd) = try Kernel.Event.Test.makePipe()
            defer {
                Kernel.Event.Test.closeNoThrow(readFd)
                Kernel.Event.Test.closeNoThrow(writeFd)
            }

            let epfd = try Kernel.Event.Poll.create(flags: .cloexec)
            defer { Kernel.Event.Test.closeNoThrow(epfd) }

            let event = Kernel.Event.Poll.Event(
                events: .in,
                data: Kernel.Event.Poll.Data(UInt64(readFd.rawValue))
            )

            // Should not throw
            try Kernel.Event.Poll.ctl(epfd, op: .add, fd: readFd, event: event)
        }

        @Test("ctl invalid descriptor throws error")
        func ctlInvalidDescriptorThrows() throws {
            let epfd = try Kernel.Event.Poll.create(flags: .cloexec)
            defer { Kernel.Event.Test.closeNoThrow(epfd) }

            let invalidFd = Kernel.Descriptor(rawValue: -1)
            let event = Kernel.Event.Poll.Event(
                events: .in,
                data: .zero
            )

            #expect(throws: Kernel.Event.Poll.Error.self) {
                try Kernel.Event.Poll.ctl(epfd, op: .add, fd: invalidFd, event: event)
            }
        }

        // MARK: - Wait Tests

        @Test("wait with no events times out and returns zero")
        func waitTimesOutWithNoEvents() throws {
            let epfd = try Kernel.Event.Poll.create(flags: .cloexec)
            defer { Kernel.Event.Test.closeNoThrow(epfd) }

            // Create a placeholder event
            let placeholder = Kernel.Event.Poll.Event(events: .in, data: .zero)
            var results: [Kernel.Event.Poll.Event] = Array(repeating: placeholder, count: 10)

            let count = try Kernel.Event.Poll.wait(epfd, events: &results, timeout: .milliseconds(10))

            #expect(count == 0)
        }

        @Test("wait returns readability after write to pipe")
        func waitReturnsReadabilityAfterWrite() throws {
            let (readFd, writeFd) = try Kernel.Event.Test.makePipe()
            defer {
                Kernel.Event.Test.closeNoThrow(readFd)
                Kernel.Event.Test.closeNoThrow(writeFd)
            }

            let epfd = try Kernel.Event.Poll.create(flags: .cloexec)
            defer { Kernel.Event.Test.closeNoThrow(epfd) }

            // Register read interest
            let registerEvent = Kernel.Event.Poll.Event(
                events: .in,
                data: Kernel.Event.Poll.Data(UInt64(readFd.rawValue))
            )
            try Kernel.Event.Poll.ctl(epfd, op: .add, fd: readFd, event: registerEvent)

            // Write a byte to make the pipe readable
            Kernel.Event.Test.writeByte(writeFd)

            // Wait for events
            let placeholder = Kernel.Event.Poll.Event(events: .in, data: .zero)
            var results: [Kernel.Event.Poll.Event] = Array(repeating: placeholder, count: 10)
            let count = try Kernel.Event.Poll.wait(epfd, events: &results, timeout: .milliseconds(100))

            #expect(count == 1)
            #expect(results[0].events.contains(.in))
        }

        @Test("ctl delete removes registration")
        func ctlDeleteRemovesRegistration() throws {
            let (readFd, writeFd) = try Kernel.Event.Test.makePipe()
            defer {
                Kernel.Event.Test.closeNoThrow(readFd)
                Kernel.Event.Test.closeNoThrow(writeFd)
            }

            let epfd = try Kernel.Event.Poll.create(flags: .cloexec)
            defer { Kernel.Event.Test.closeNoThrow(epfd) }

            // Add registration
            let event = Kernel.Event.Poll.Event(
                events: .in,
                data: Kernel.Event.Poll.Data(UInt64(readFd.rawValue))
            )
            try Kernel.Event.Poll.ctl(epfd, op: .add, fd: readFd, event: event)

            // Delete registration
            try Kernel.Event.Poll.ctl(epfd, op: .delete, fd: readFd, event: nil)

            // Write data
            Kernel.Event.Test.writeByte(writeFd)

            // Wait - should return 0 since registration was deleted
            let placeholder = Kernel.Event.Poll.Event(events: .in, data: .zero)
            var results: [Kernel.Event.Poll.Event] = Array(repeating: placeholder, count: 10)
            let count = try Kernel.Event.Poll.wait(epfd, events: &results, timeout: .milliseconds(50))

            #expect(count == 0)
        }

        @Test("wait on closed epoll throws error")
        func waitOnClosedEpollThrows() throws {
            let epfd = try Kernel.Event.Poll.create(flags: .cloexec)

            // Close the epoll
            Kernel.Event.Test.closeNoThrow(epfd)

            // Now attempt to wait on it - should throw
            let placeholder = Kernel.Event.Poll.Event(events: .in, data: .zero)
            var results: [Kernel.Event.Poll.Event] = Array(repeating: placeholder, count: 10)

            #expect(throws: Kernel.Event.Poll.Error.self) {
                _ = try Kernel.Event.Poll.wait(epfd, events: &results, timeout: .milliseconds(10))
            }
        }

        // MARK: - Multiple Descriptor Tests

        @Test("wait detects multiple readable pipes")
        func waitDetectsMultipleReadablePipes() throws {
            let (readFd1, writeFd1) = try Kernel.Event.Test.makePipe()
            let (readFd2, writeFd2) = try Kernel.Event.Test.makePipe()
            defer {
                Kernel.Event.Test.closeNoThrow(readFd1)
                Kernel.Event.Test.closeNoThrow(writeFd1)
                Kernel.Event.Test.closeNoThrow(readFd2)
                Kernel.Event.Test.closeNoThrow(writeFd2)
            }

            let epfd = try Kernel.Event.Poll.create(flags: .cloexec)
            defer { Kernel.Event.Test.closeNoThrow(epfd) }

            // Register both pipes
            let event1 = Kernel.Event.Poll.Event(
                events: .in,
                data: Kernel.Event.Poll.Data(UInt64(readFd1.rawValue))
            )
            let event2 = Kernel.Event.Poll.Event(
                events: .in,
                data: Kernel.Event.Poll.Data(UInt64(readFd2.rawValue))
            )
            try Kernel.Event.Poll.ctl(epfd, op: .add, fd: readFd1, event: event1)
            try Kernel.Event.Poll.ctl(epfd, op: .add, fd: readFd2, event: event2)

            // Write to both pipes
            Kernel.Event.Test.writeByte(writeFd1)
            Kernel.Event.Test.writeByte(writeFd2)

            // Wait - should return 2 events
            let placeholder = Kernel.Event.Poll.Event(events: .in, data: .zero)
            var results: [Kernel.Event.Poll.Event] = Array(repeating: placeholder, count: 10)
            let count = try Kernel.Event.Poll.wait(epfd, events: &results, timeout: .milliseconds(100))

            #expect(count == 2)
            #expect(results[0].events.contains(.in))
            #expect(results[1].events.contains(.in))
        }
    }

#endif
