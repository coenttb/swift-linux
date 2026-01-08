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

    extension Kernel.IO.Uring.Error {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IO.Uring.Error.Test.Unit {
        @Test("setup case exists")
        func setupCase() {
            let code = Kernel.Error.Code.posix(1)
            let error = Kernel.IO.Uring.Error.setup(code)
            if case .setup(let c) = error {
                #expect(c == code)
            } else {
                Issue.record("Expected .setup case")
            }
        }

        @Test("enter case exists")
        func enterCase() {
            let code = Kernel.Error.Code.posix(2)
            let error = Kernel.IO.Uring.Error.enter(code)
            if case .enter(let c) = error {
                #expect(c == code)
            } else {
                Issue.record("Expected .enter case")
            }
        }

        @Test("register case exists")
        func registerCase() {
            let code = Kernel.Error.Code.posix(3)
            let error = Kernel.IO.Uring.Error.register(code)
            if case .register(let c) = error {
                #expect(c == code)
            } else {
                Issue.record("Expected .register case")
            }
        }

        @Test("interrupted case exists")
        func interruptedCase() {
            let error = Kernel.IO.Uring.Error.interrupted
            if case .interrupted = error {
                // Expected
            } else {
                Issue.record("Expected .interrupted case")
            }
        }
    }

    // MARK: - Description Tests

    extension Kernel.IO.Uring.Error.Test.Unit {
        @Test("setup description format")
        func setupDescription() {
            let error = Kernel.IO.Uring.Error.setup(.posix(1))
            #expect(error.description.contains("io_uring_setup"))
        }

        @Test("enter description format")
        func enterDescription() {
            let error = Kernel.IO.Uring.Error.enter(.posix(1))
            #expect(error.description.contains("io_uring_enter"))
        }

        @Test("register description format")
        func registerDescription() {
            let error = Kernel.IO.Uring.Error.register(.posix(1))
            #expect(error.description.contains("io_uring_register"))
        }

        @Test("interrupted description format")
        func interruptedDescription() {
            let error = Kernel.IO.Uring.Error.interrupted
            #expect(error.description.contains("interrupted"))
        }
    }

    // MARK: - Conformance Tests

    extension Kernel.IO.Uring.Error.Test.Unit {
        @Test("Error conforms to Swift.Error")
        func isSwiftError() {
            let error: any Swift.Error = Kernel.IO.Uring.Error.interrupted
            #expect(error is Kernel.IO.Uring.Error)
        }

        @Test("Error is Sendable")
        func isSendable() {
            let error: any Sendable = Kernel.IO.Uring.Error.interrupted
            #expect(error is Kernel.IO.Uring.Error)
        }

        @Test("Error is Equatable")
        func isEquatable() {
            let a = Kernel.IO.Uring.Error.interrupted
            let b = Kernel.IO.Uring.Error.interrupted
            let c = Kernel.IO.Uring.Error.setup(.posix(1))
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Error is Hashable")
        func isHashable() {
            var set = Set<Kernel.IO.Uring.Error>()
            set.insert(.setup(.posix(1)))
            set.insert(.enter(.posix(2)))
            set.insert(.register(.posix(3)))
            set.insert(.interrupted)
            set.insert(.setup(.posix(1)))  // duplicate
            #expect(set.count == 4)
        }

        @Test("Error is CustomStringConvertible")
        func isCustomStringConvertible() {
            let error: any CustomStringConvertible = Kernel.IO.Uring.Error.interrupted
            #expect(!error.description.isEmpty)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IO.Uring.Error.Test.EdgeCase {
        @Test("all cases are distinct")
        func allCasesDistinct() {
            let code = Kernel.Error.Code.posix(1)
            let cases: [Kernel.IO.Uring.Error] = [
                .setup(code),
                .enter(code),
                .register(code),
                .interrupted,
            ]

            for i in 0..<cases.count {
                for j in (i + 1)..<cases.count {
                    #expect(cases[i] != cases[j])
                }
            }
        }

        @Test("same case with different codes are distinct")
        func differentCodesDistinct() {
            let a = Kernel.IO.Uring.Error.setup(.posix(1))
            let b = Kernel.IO.Uring.Error.setup(.posix(2))
            #expect(a != b)
        }

        @Test("all descriptions are non-empty")
        func allDescriptionsNonEmpty() {
            let code = Kernel.Error.Code.posix(1)
            let cases: [Kernel.IO.Uring.Error] = [
                .setup(code),
                .enter(code),
                .register(code),
                .interrupted,
            ]

            for error in cases {
                #expect(!error.description.isEmpty)
            }
        }
    }
#endif
