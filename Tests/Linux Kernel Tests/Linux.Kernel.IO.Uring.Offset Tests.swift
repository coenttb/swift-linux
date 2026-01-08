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

    /// Tests for Kernel.IO.Uring.Offset (typealias to Coordinate.X.Value).
    extension Kernel.IO.Uring {
        @Suite
        enum OffsetTest {
            // MARK: - Unit Tests

            @Suite struct Unit {
                @Test("Offset type exists")
                func typeExists() {
                    let _: Kernel.IO.Uring.Offset.Type = Kernel.IO.Uring.Offset.self
                }

                @Test("Offset.zero constant")
                func zeroConstant() {
                    let zero = Kernel.IO.Uring.Offset.zero
                    #expect(zero == 0)
                }

                @Test("Offset.current constant")
                func currentConstant() {
                    let current = Kernel.IO.Uring.Offset.current
                    #expect(current.rawValue == UInt64.max)
                }

                @Test("Offset from File.Offset")
                func fromFileOffset() {
                    let offset = Kernel.IO.Uring.Offset(Kernel.File.Offset(4096))
                    #expect(offset == 4096)
                }

                @Test("current description")
                func currentDescription() {
                    let current = Kernel.IO.Uring.Offset.current
                    #expect(current.description == "current")
                }

                @Test("zero description")
                func zeroDescription() {
                    let zero = Kernel.IO.Uring.Offset.zero
                    #expect(zero.description == "0")
                }

                @Test("numeric offset description")
                func numericDescription() {
                    let offset = Kernel.IO.Uring.Offset(Kernel.File.Offset(4096))
                    #expect(offset.description == "4096")
                }

                @Test("Offset is Sendable")
                func isSendable() {
                    let offset: any Sendable = Kernel.IO.Uring.Offset.zero
                    #expect(offset is Kernel.IO.Uring.Offset)
                }

                @Test("Offset is Equatable")
                func isEquatable() {
                    let a = Kernel.IO.Uring.Offset(Kernel.File.Offset(100))
                    let b = Kernel.IO.Uring.Offset(Kernel.File.Offset(100))
                    let c = Kernel.IO.Uring.Offset(Kernel.File.Offset(200))
                    #expect(a == b)
                    #expect(a != c)
                }

                @Test("Offset is Hashable")
                func isHashable() {
                    var set = Set<Kernel.IO.Uring.Offset>()
                    set.insert(.zero)
                    set.insert(.current)
                    set.insert(Kernel.IO.Uring.Offset(Kernel.File.Offset(100)))
                    set.insert(.zero)  // duplicate
                    #expect(set.count == 3)
                }

                @Test("Offset from positive File.Offset")
                func fromPositiveFileOffset() {
                    let fileOffset = Kernel.File.Offset(1000)
                    let offset = Kernel.IO.Uring.Offset(fileOffset)
                    #expect(offset == 1000)
                }

                @Test("Offset from zero File.Offset")
                func fromZeroFileOffset() {
                    let fileOffset = Kernel.File.Offset(0)
                    let offset = Kernel.IO.Uring.Offset(fileOffset)
                    #expect(offset == 0)
                }

                @Test("Offset from negative File.Offset becomes current")
                func fromNegativeFileOffset() {
                    let fileOffset = Kernel.File.Offset(-1)
                    let offset = Kernel.IO.Uring.Offset(fileOffset)
                    #expect(offset == .current)
                }
            }

            // MARK: - Edge Cases

            @Suite struct EdgeCase {
                @Test("zero and current are distinct")
                func zeroCurrentDistinct() {
                    #expect(Kernel.IO.Uring.Offset.zero != Kernel.IO.Uring.Offset.current)
                }

                @Test("max UInt64 value equals current")
                func maxValueEqualsCurrent() {
                    let max = Kernel.IO.Uring.Offset(UInt64.max)
                    #expect(max == .current)
                }
            }
        }
    }
#endif
