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

    extension Kernel.IOUring.Priority {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IOUring.Priority.Test.Unit {
        @Test("Priority from rawValue")
        func rawValueInit() {
            let priority = Kernel.IOUring.Priority(rawValue: 100)
            #expect(priority.rawValue == 100)
        }

        @Test("Priority from UInt16")
        func uint16Init() {
            let priority = Kernel.IOUring.Priority(50)
            #expect(priority.rawValue == 50)
        }

        @Test("Priority.default constant")
        func defaultConstant() {
            #expect(Kernel.IOUring.Priority.default.rawValue == 0)
        }

        @Test("Priority.normal constant")
        func normalConstant() {
            #expect(Kernel.IOUring.Priority.normal.rawValue == 0)
        }

        @Test("Priority integer literal")
        func integerLiteral() {
            let priority: Kernel.IOUring.Priority = 42
            #expect(priority.rawValue == 42)
        }

        @Test("Priority description")
        func description() {
            let priority = Kernel.IOUring.Priority(123)
            #expect(priority.description == "123")
        }
    }

    // MARK: - Conformance Tests

    extension Kernel.IOUring.Priority.Test.Unit {
        @Test("Priority is Sendable")
        func isSendable() {
            let priority: any Sendable = Kernel.IOUring.Priority(0)
            #expect(priority is Kernel.IOUring.Priority)
        }

        @Test("Priority is Equatable")
        func isEquatable() {
            let a = Kernel.IOUring.Priority(10)
            let b = Kernel.IOUring.Priority(10)
            let c = Kernel.IOUring.Priority(20)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Priority is Hashable")
        func isHashable() {
            var set = Set<Kernel.IOUring.Priority>()
            set.insert(.default)
            set.insert(Kernel.IOUring.Priority(100))
            set.insert(.default)  // duplicate
            #expect(set.count == 2)
        }

        @Test("Priority is Comparable")
        func isComparable() {
            let low = Kernel.IOUring.Priority(10)
            let high = Kernel.IOUring.Priority(100)
            #expect(low < high)
            #expect(high > low)
        }

        @Test("Priority is RawRepresentable")
        func isRawRepresentable() {
            let priority = Kernel.IOUring.Priority(rawValue: 50)
            #expect(priority.rawValue == 50)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IOUring.Priority.Test.EdgeCase {
        @Test("Priority max value")
        func maxValue() {
            let priority = Kernel.IOUring.Priority(UInt16.max)
            #expect(priority.rawValue == UInt16.max)
        }

        @Test("default and normal are equal")
        func defaultEqualsNormal() {
            #expect(Kernel.IOUring.Priority.default == Kernel.IOUring.Priority.normal)
        }

        @Test("Priority ordering")
        func ordering() {
            let priorities = [
                Kernel.IOUring.Priority(100),
                Kernel.IOUring.Priority(50),
                Kernel.IOUring.Priority(200),
            ]
            let sorted = priorities.sorted()
            #expect(sorted[0].rawValue == 50)
            #expect(sorted[1].rawValue == 100)
            #expect(sorted[2].rawValue == 200)
        }
    }
#endif
