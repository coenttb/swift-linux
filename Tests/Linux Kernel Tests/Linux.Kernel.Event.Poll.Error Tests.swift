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


    extension Kernel.Event.Poll.Error {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.Event.Poll.Error.Test.Unit {
        @Test("create case stores error code")
        func createCase() {
            let code = Kernel.Error.Code.posix(EINVAL)
            let error = Kernel.Event.Poll.Error.create(code)
            if case .create(let storedCode) = error {
                #expect(storedCode == code)
            } else {
                Issue.record("Expected .create case")
            }
        }

        @Test("ctl case stores error code")
        func ctlCase() {
            let code = Kernel.Error.Code.posix(EBADF)
            let error = Kernel.Event.Poll.Error.ctl(code)
            if case .ctl(let storedCode) = error {
                #expect(storedCode == code)
            } else {
                Issue.record("Expected .ctl case")
            }
        }

        @Test("wait case stores error code")
        func waitCase() {
            let code = Kernel.Error.Code.posix(EFAULT)
            let error = Kernel.Event.Poll.Error.wait(code)
            if case .wait(let storedCode) = error {
                #expect(storedCode == code)
            } else {
                Issue.record("Expected .wait case")
            }
        }

        @Test("interrupted case exists")
        func interruptedCase() {
            let error = Kernel.Event.Poll.Error.interrupted
            if case .interrupted = error {
                // Expected
            } else {
                Issue.record("Expected .interrupted case")
            }
        }
    }

    // MARK: - Description Tests

    extension Kernel.Event.Poll.Error.Test.Unit {
        @Test("create description format")
        func createDescription() {
            let code = Kernel.Error.Code.posix(EINVAL)
            let error = Kernel.Event.Poll.Error.create(code)
            #expect(error.description.contains("epoll_create1 failed"))
        }

        @Test("ctl description format")
        func ctlDescription() {
            let code = Kernel.Error.Code.posix(EBADF)
            let error = Kernel.Event.Poll.Error.ctl(code)
            #expect(error.description.contains("epoll_ctl failed"))
        }

        @Test("wait description format")
        func waitDescription() {
            let code = Kernel.Error.Code.posix(EFAULT)
            let error = Kernel.Event.Poll.Error.wait(code)
            #expect(error.description.contains("epoll_wait failed"))
        }

        @Test("interrupted description")
        func interruptedDescription() {
            let error = Kernel.Event.Poll.Error.interrupted
            #expect(error.description == "operation interrupted")
        }
    }

    // MARK: - Conformance Tests

    extension Kernel.Event.Poll.Error.Test.Unit {
        @Test("Error conforms to Swift.Error")
        func isSwiftError() {
            let error: any Swift.Error = Kernel.Event.Poll.Error.interrupted
            #expect(error is Kernel.Event.Poll.Error)
        }

        @Test("Error is Sendable")
        func isSendable() {
            let error: any Sendable = Kernel.Event.Poll.Error.interrupted
            #expect(error is Kernel.Event.Poll.Error)
        }

        @Test("Error is Equatable")
        func isEquatable() {
            let code = Kernel.Error.Code.posix(EINVAL)
            let a = Kernel.Event.Poll.Error.create(code)
            let b = Kernel.Event.Poll.Error.create(code)
            let c = Kernel.Event.Poll.Error.ctl(code)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Error is Hashable")
        func isHashable() {
            var set = Set<Kernel.Event.Poll.Error>()
            set.insert(.interrupted)
            set.insert(.create(Kernel.Error.Code.posix(EINVAL)))
            set.insert(.interrupted)  // duplicate
            #expect(set.count == 2)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.Event.Poll.Error.Test.EdgeCase {
        @Test("different error codes are not equal")
        func differentCodesNotEqual() {
            let error1 = Kernel.Event.Poll.Error.create(Kernel.Error.Code.posix(EINVAL))
            let error2 = Kernel.Event.Poll.Error.create(Kernel.Error.Code.posix(ENOMEM))
            #expect(error1 != error2)
        }

        @Test("same code different case not equal")
        func samCodeDifferentCaseNotEqual() {
            let code = Kernel.Error.Code.posix(EINVAL)
            let error1 = Kernel.Event.Poll.Error.create(code)
            let error2 = Kernel.Event.Poll.Error.ctl(code)
            #expect(error1 != error2)
        }

        @Test("interrupted equals itself")
        func interruptedEqualsSelf() {
            #expect(Kernel.Event.Poll.Error.interrupted == .interrupted)
        }
    }
#endif
