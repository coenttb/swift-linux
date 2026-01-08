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

    extension Kernel.IO.Uring.Buffer {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IO.Uring.Buffer.Test.Unit {
        @Test("Buffer namespace exists")
        func namespaceExists() {
            _ = Kernel.IO.Uring.Buffer.self
        }

        @Test("Buffer is an enum")
        func isEnum() {
            let _: Kernel.IO.Uring.Buffer.Type = Kernel.IO.Uring.Buffer.self
        }
    }

    // MARK: - Index Tests

    extension Kernel.IO.Uring.Buffer.Test.Unit {
        @Test("Index from rawValue")
        func indexRawValueInit() {
            let index = Kernel.IO.Uring.Buffer.Index(rawValue: 5)
            #expect(index.rawValue == 5)
        }

        @Test("Index from UInt16")
        func indexUInt16Init() {
            let index = Kernel.IO.Uring.Buffer.Index(10)
            #expect(index.rawValue == 10)
        }

        @Test("Index.first constant")
        func indexFirst() {
            #expect(Kernel.IO.Uring.Buffer.Index.first.rawValue == 0)
        }

        @Test("Index integer literal")
        func indexIntegerLiteral() {
            let index: Kernel.IO.Uring.Buffer.Index = 42
            #expect(index.rawValue == 42)
        }

        @Test("Index description")
        func indexDescription() {
            let index = Kernel.IO.Uring.Buffer.Index(123)
            #expect(index.description == "123")
        }

        @Test("Index is Sendable")
        func indexIsSendable() {
            let index: any Sendable = Kernel.IO.Uring.Buffer.Index(0)
            #expect(index is Kernel.IO.Uring.Buffer.Index)
        }

        @Test("Index is Equatable")
        func indexIsEquatable() {
            let a = Kernel.IO.Uring.Buffer.Index(5)
            let b = Kernel.IO.Uring.Buffer.Index(5)
            let c = Kernel.IO.Uring.Buffer.Index(10)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Index is Hashable")
        func indexIsHashable() {
            var set = Set<Kernel.IO.Uring.Buffer.Index>()
            set.insert(.first)
            set.insert(Kernel.IO.Uring.Buffer.Index(1))
            set.insert(.first)  // duplicate
            #expect(set.count == 2)
        }
    }

    // MARK: - Group Tests

    extension Kernel.IO.Uring.Buffer.Test.Unit {
        @Test("Group from rawValue")
        func groupRawValueInit() {
            let group = Kernel.IO.Uring.Buffer.Group(rawValue: 5)
            #expect(group.rawValue == 5)
        }

        @Test("Group from UInt16")
        func groupUInt16Init() {
            let group = Kernel.IO.Uring.Buffer.Group(10)
            #expect(group.rawValue == 10)
        }

        @Test("Group integer literal")
        func groupIntegerLiteral() {
            let group: Kernel.IO.Uring.Buffer.Group = 42
            #expect(group.rawValue == 42)
        }

        @Test("Group description")
        func groupDescription() {
            let group = Kernel.IO.Uring.Buffer.Group(123)
            #expect(group.description == "123")
        }

        @Test("Group is Sendable")
        func groupIsSendable() {
            let group: any Sendable = Kernel.IO.Uring.Buffer.Group(0)
            #expect(group is Kernel.IO.Uring.Buffer.Group)
        }

        @Test("Group is Equatable")
        func groupIsEquatable() {
            let a = Kernel.IO.Uring.Buffer.Group(5)
            let b = Kernel.IO.Uring.Buffer.Group(5)
            let c = Kernel.IO.Uring.Buffer.Group(10)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Group is Hashable")
        func groupIsHashable() {
            var set = Set<Kernel.IO.Uring.Buffer.Group>()
            set.insert(Kernel.IO.Uring.Buffer.Group(0))
            set.insert(Kernel.IO.Uring.Buffer.Group(1))
            set.insert(Kernel.IO.Uring.Buffer.Group(0))  // duplicate
            #expect(set.count == 2)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IO.Uring.Buffer.Test.EdgeCase {
        @Test("Index max value")
        func indexMaxValue() {
            let index = Kernel.IO.Uring.Buffer.Index(UInt16.max)
            #expect(index.rawValue == UInt16.max)
        }

        @Test("Group max value")
        func groupMaxValue() {
            let group = Kernel.IO.Uring.Buffer.Group(UInt16.max)
            #expect(group.rawValue == UInt16.max)
        }
    }
#endif
