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

    /// Tests for Kernel.IO.Uring.Personality.
    extension Kernel.IO.Uring {
        @Suite
        enum PersonalityTest {
            // MARK: - Unit Tests

            @Suite struct Unit {
                @Test("Personality namespace exists")
                func namespaceExists() {
                    _ = Kernel.IO.Uring.Personality.self
                }

                @Test("Personality is an enum")
                func isEnum() {
                    let _: Kernel.IO.Uring.Personality.Type = Kernel.IO.Uring.Personality.self
                }

                @Test("ID type exists")
                func idTypeExists() {
                    let _: Kernel.IO.Uring.Personality.ID.Type = Kernel.IO.Uring.Personality.ID.self
                }

                @Test("ID.none constant")
                func idNoneConstant() {
                    let none = Kernel.IO.Uring.Personality.ID.none
                    #expect(none.rawValue == 0)
                }

                @Test("ID from UInt16")
                func idFromUInt16() {
                    let id = Kernel.IO.Uring.Personality.ID(42)
                    #expect(id.rawValue == 42)
                }

                @Test("ID is Sendable")
                func idIsSendable() {
                    let id: any Sendable = Kernel.IO.Uring.Personality.ID.none
                    #expect(id is Kernel.IO.Uring.Personality.ID)
                }

                @Test("ID is Equatable")
                func idIsEquatable() {
                    let a = Kernel.IO.Uring.Personality.ID(10)
                    let b = Kernel.IO.Uring.Personality.ID(10)
                    let c = Kernel.IO.Uring.Personality.ID(20)
                    #expect(a == b)
                    #expect(a != c)
                }

                @Test("ID is Hashable")
                func idIsHashable() {
                    var set = Set<Kernel.IO.Uring.Personality.ID>()
                    set.insert(.none)
                    set.insert(Kernel.IO.Uring.Personality.ID(1))
                    set.insert(.none)  // duplicate
                    #expect(set.count == 2)
                }
            }

            // MARK: - Edge Cases

            @Suite struct EdgeCase {
                @Test("ID max value")
                func idMaxValue() {
                    let id = Kernel.IO.Uring.Personality.ID(UInt16.max)
                    #expect(id.rawValue == UInt16.max)
                }

                @Test("ID rawValue roundtrip")
                func idRawValueRoundtrip() {
                    for value: UInt16 in [0, 1, 100, UInt16.max] {
                        let id = Kernel.IO.Uring.Personality.ID(value)
                        #expect(id.rawValue == value)
                    }
                }
            }
        }
    }
#endif
