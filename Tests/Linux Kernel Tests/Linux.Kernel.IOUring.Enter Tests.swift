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


    extension Kernel.IOUring.EnterFlags {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IOUring.EnterFlags.Test.Unit {
        @Test("EnterFlags from rawValue")
        func rawValueInit() {
            let flags = Kernel.IOUring.EnterFlags(rawValue: 0x07)
            #expect(flags.rawValue == 0x07)
        }

        @Test("getEvents has rawValue 1")
        func getEventsRawValue() {
            #expect(Kernel.IOUring.EnterFlags.getEvents.rawValue == 1)
        }

        @Test("sqWakeup has rawValue 2")
        func sqWakeupRawValue() {
            #expect(Kernel.IOUring.EnterFlags.sqWakeup.rawValue == 2)
        }

        @Test("sqWait has rawValue 4")
        func sqWaitRawValue() {
            #expect(Kernel.IOUring.EnterFlags.sqWait.rawValue == 4)
        }

        @Test("extArg has rawValue 8")
        func extArgRawValue() {
            #expect(Kernel.IOUring.EnterFlags.extArg.rawValue == 8)
        }

        @Test("registeredRing has rawValue 16")
        func registeredRingRawValue() {
            #expect(Kernel.IOUring.EnterFlags.registeredRing.rawValue == 16)
        }
    }

    // MARK: - OptionSet Tests

    extension Kernel.IOUring.EnterFlags.Test.Unit {
        @Test("flags combine with union")
        func flagsCombine() {
            let combined = Kernel.IOUring.EnterFlags.getEvents.union(.sqWakeup)
            #expect(combined.contains(.getEvents))
            #expect(combined.contains(.sqWakeup))
            #expect(!combined.contains(.sqWait))
        }

        @Test("empty flags is empty")
        func emptyFlags() {
            let flags: Kernel.IOUring.EnterFlags = []
            #expect(flags.isEmpty)
            #expect(flags.rawValue == 0)
        }

        @Test("flags can be created with array literal")
        func arrayLiteral() {
            let flags: Kernel.IOUring.EnterFlags = [.getEvents, .sqWakeup]
            #expect(flags.contains(.getEvents))
            #expect(flags.contains(.sqWakeup))
        }

        @Test("flags intersection")
        func intersection() {
            let a: Kernel.IOUring.EnterFlags = [.getEvents, .sqWakeup]
            let b: Kernel.IOUring.EnterFlags = [.sqWakeup, .sqWait]
            let intersection = a.intersection(b)
            #expect(intersection.contains(.sqWakeup))
            #expect(!intersection.contains(.getEvents))
            #expect(!intersection.contains(.sqWait))
        }
    }

    // MARK: - Conformance Tests

    extension Kernel.IOUring.EnterFlags.Test.Unit {
        @Test("EnterFlags is Sendable")
        func isSendable() {
            let flags: any Sendable = Kernel.IOUring.EnterFlags.getEvents
            #expect(flags is Kernel.IOUring.EnterFlags)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IOUring.EnterFlags.Test.EdgeCase {
        @Test("flags are distinct")
        func flagsDistinct() {
            let flags: [Kernel.IOUring.EnterFlags] = [
                .getEvents, .sqWakeup, .sqWait, .extArg, .registeredRing,
            ]

            for i in 0..<flags.count {
                for j in (i + 1)..<flags.count {
                    #expect(flags[i] != flags[j])
                }
            }
        }

        @Test("all flags combined")
        func allFlagsCombined() {
            let all: Kernel.IOUring.EnterFlags = [
                .getEvents, .sqWakeup, .sqWait, .extArg, .registeredRing,
            ]
            #expect(all.rawValue == 0x1F)
        }
    }
#endif
