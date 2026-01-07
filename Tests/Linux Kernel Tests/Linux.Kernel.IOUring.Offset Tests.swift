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

    extension Kernel.IOUring.Offset {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IOUring.Offset.Test.Unit {
        @Test("Offset type exists")
        func typeExists() {
            let _: Kernel.IOUring.Offset.Type = Kernel.IOUring.Offset.self
        }

        @Test("Offset.zero constant")
        func zeroConstant() {
            let zero = Kernel.IOUring.Offset.zero
            #expect(zero == 0)
        }

        @Test("Offset.current constant")
        func currentConstant() {
            let current = Kernel.IOUring.Offset.current
            #expect(current.rawValue == UInt64.max)
        }

        @Test("Offset from UInt64")
        func fromUInt64() {
            let offset = Kernel.IOUring.Offset(4096)
            #expect(offset == 4096)
        }
    }

    // MARK: - Description Tests

    extension Kernel.IOUring.Offset.Test.Unit {
        @Test("current description")
        func currentDescription() {
            let current = Kernel.IOUring.Offset.current
            #expect(current.description == "current")
        }

        @Test("zero description")
        func zeroDescription() {
            let zero = Kernel.IOUring.Offset.zero
            #expect(zero.description == "0")
        }

        @Test("numeric offset description")
        func numericDescription() {
            let offset = Kernel.IOUring.Offset(4096)
            #expect(offset.description == "4096")
        }
    }

    // MARK: - Conformance Tests

    extension Kernel.IOUring.Offset.Test.Unit {
        @Test("Offset is Sendable")
        func isSendable() {
            let offset: any Sendable = Kernel.IOUring.Offset.zero
            #expect(offset is Kernel.IOUring.Offset)
        }

        @Test("Offset is Equatable")
        func isEquatable() {
            let a = Kernel.IOUring.Offset(100)
            let b = Kernel.IOUring.Offset(100)
            let c = Kernel.IOUring.Offset(200)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Offset is Hashable")
        func isHashable() {
            var set = Set<Kernel.IOUring.Offset>()
            set.insert(.zero)
            set.insert(.current)
            set.insert(Kernel.IOUring.Offset(100))
            set.insert(.zero)  // duplicate
            #expect(set.count == 3)
        }
    }

    // MARK: - File Offset Conversion Tests

    extension Kernel.IOUring.Offset.Test.Unit {
        @Test("Offset from positive File.Offset")
        func fromPositiveFileOffset() {
            let fileOffset = Kernel.File.Offset(1000)
            let offset = Kernel.IOUring.Offset(fileOffset)
            #expect(offset == 1000)
        }

        @Test("Offset from zero File.Offset")
        func fromZeroFileOffset() {
            let fileOffset = Kernel.File.Offset(0)
            let offset = Kernel.IOUring.Offset(fileOffset)
            #expect(offset == 0)
        }

        @Test("Offset from negative File.Offset becomes current")
        func fromNegativeFileOffset() {
            let fileOffset = Kernel.File.Offset(-1)
            let offset = Kernel.IOUring.Offset(fileOffset)
            #expect(offset == .current)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IOUring.Offset.Test.EdgeCase {
        @Test("zero and current are distinct")
        func zeroCurrentDistinct() {
            #expect(Kernel.IOUring.Offset.zero != Kernel.IOUring.Offset.current)
        }

        @Test("max UInt64 value equals current")
        func maxValueEqualsCurrent() {
            let max = Kernel.IOUring.Offset(UInt64.max)
            #expect(max == .current)
        }
    }
#endif
