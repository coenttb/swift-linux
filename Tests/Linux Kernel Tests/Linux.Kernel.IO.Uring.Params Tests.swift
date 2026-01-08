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
    import StandardsTestSupport
    import Testing

    import Kernel_Primitives
    @testable import Linux_Kernel

    extension Kernel.IO.Uring.Params {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IO.Uring.Params.Test.Unit {
        @Test("Params default init")
        func defaultInit() {
            let params = Kernel.IO.Uring.Params()
            #expect(params.sqEntries == 0)
            #expect(params.cqEntries == 0)
            #expect(params.flags.isEmpty)
            #expect(params.features == 0)
        }

        @Test("Params init with flags")
        func initWithFlags() {
            let params = Kernel.IO.Uring.Params(flags: .sqPoll)
            #expect(params.flags == .sqPoll)
        }

        @Test("Params init with submission configuration")
        func initWithSubmissionConfig() {
            let thread = Kernel.IO.Uring.Params.Submission.Thread(cpu: 2, idle: 1000)
            let config = Kernel.IO.Uring.Params.Submission(thread: thread)
            let params = Kernel.IO.Uring.Params(submission: config)
            #expect(params.submission.thread.cpu == 2)
            #expect(params.submission.thread.idle == 1000)
        }
    }

    // MARK: - Submission Tests

    extension Kernel.IO.Uring.Params.Test.Unit {
        @Test("Submission default init")
        func submissionConfigDefaultInit() {
            let config = Kernel.IO.Uring.Params.Submission()
            #expect(config.thread.cpu == 0)
            #expect(config.thread.idle == 0)
        }

        @Test("Thread configuration")
        func threadConfiguration() {
            let thread = Kernel.IO.Uring.Params.Submission.Thread(cpu: 4, idle: 5000)
            #expect(thread.cpu == 4)
            #expect(thread.idle == 5000)
        }
    }

    // MARK: - Conformance Tests

    extension Kernel.IO.Uring.Params.Test.Unit {
        @Test("Params is Sendable")
        func isSendable() {
            let params: any Sendable = Kernel.IO.Uring.Params()
            #expect(params is Kernel.IO.Uring.Params)
        }

        @Test("Params is Equatable")
        func isEquatable() {
            let a = Kernel.IO.Uring.Params()
            let b = Kernel.IO.Uring.Params()
            let c = Kernel.IO.Uring.Params(flags: .sqPoll)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Submission is Sendable")
        func submissionConfigIsSendable() {
            let config: any Sendable = Kernel.IO.Uring.Params.Submission()
            #expect(config is Kernel.IO.Uring.Params.Submission)
        }

        @Test("Submission is Equatable")
        func submissionConfigIsEquatable() {
            let a = Kernel.IO.Uring.Params.Submission()
            let b = Kernel.IO.Uring.Params.Submission()
            #expect(a == b)
        }

        @Test("Thread is Sendable")
        func threadIsSendable() {
            let thread: any Sendable = Kernel.IO.Uring.Params.Submission.Thread()
            #expect(thread is Kernel.IO.Uring.Params.Submission.Thread)
        }

        @Test("Thread is Equatable")
        func threadIsEquatable() {
            let a = Kernel.IO.Uring.Params.Submission.Thread(cpu: 1, idle: 100)
            let b = Kernel.IO.Uring.Params.Submission.Thread(cpu: 1, idle: 100)
            let c = Kernel.IO.Uring.Params.Submission.Thread(cpu: 2, idle: 200)
            #expect(a == b)
            #expect(a != c)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IO.Uring.Params.Test.EdgeCase {
        @Test("Params with all flags")
        func paramsWithAllFlags() {
            let flags: Kernel.IO.Uring.Setup.Flags = [.ioPoll, .sqPoll, .sqAff]
            let params = Kernel.IO.Uring.Params(flags: flags)
            #expect(params.flags.contains(.ioPoll))
            #expect(params.flags.contains(.sqPoll))
            #expect(params.flags.contains(.sqAff))
        }

        @Test("Thread with max values")
        func threadMaxValues() {
            let thread = Kernel.IO.Uring.Params.Submission.Thread(
                cpu: UInt32.max,
                idle: UInt32.max
            )
            #expect(thread.cpu == UInt32.max)
            #expect(thread.idle == UInt32.max)
        }
    }
#endif
