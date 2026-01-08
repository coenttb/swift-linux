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

    extension Kernel.IO.Uring.Enter.Flags {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IO.Uring.Enter.Flags.Test.Unit {
        @Test("Enter.Flags from rawValue")
        func rawValueInit() {
            let flags = Kernel.IO.Uring.Enter.Flags(rawValue: 0x07)
            #expect(flags.rawValue == 0x07)
        }

        @Test("getEvents has rawValue 1")
        func getEventsRawValue() {
            #expect(Kernel.IO.Uring.Enter.Flags.getEvents.rawValue == 1)
        }

        @Test("sqWakeup has rawValue 2")
        func sqWakeupRawValue() {
            #expect(Kernel.IO.Uring.Enter.Flags.sqWakeup.rawValue == 2)
        }

        @Test("sqWait has rawValue 4")
        func sqWaitRawValue() {
            #expect(Kernel.IO.Uring.Enter.Flags.sqWait.rawValue == 4)
        }

        @Test("extArg has rawValue 8")
        func extArgRawValue() {
            #expect(Kernel.IO.Uring.Enter.Flags.extArg.rawValue == 8)
        }

        @Test("registeredRing has rawValue 16")
        func registeredRingRawValue() {
            #expect(Kernel.IO.Uring.Enter.Flags.registeredRing.rawValue == 16)
        }
    }

    // MARK: - OptionSet Tests

    extension Kernel.IO.Uring.Enter.Flags.Test.Unit {
        @Test("flags combine with union")
        func flagsCombine() {
            let combined = Kernel.IO.Uring.Enter.Flags.getEvents.union(.sqWakeup)
            #expect(combined.contains(.getEvents))
            #expect(combined.contains(.sqWakeup))
            #expect(!combined.contains(.sqWait))
        }

        @Test("empty flags is empty")
        func emptyFlags() {
            let flags: Kernel.IO.Uring.Enter.Flags = []
            #expect(flags.isEmpty)
            #expect(flags.rawValue == 0)
        }

        @Test("flags can be created with array literal")
        func arrayLiteral() {
            let flags: Kernel.IO.Uring.Enter.Flags = [.getEvents, .sqWakeup]
            #expect(flags.contains(.getEvents))
            #expect(flags.contains(.sqWakeup))
        }

        @Test("flags intersection")
        func intersection() {
            let a: Kernel.IO.Uring.Enter.Flags = [.getEvents, .sqWakeup]
            let b: Kernel.IO.Uring.Enter.Flags = [.sqWakeup, .sqWait]
            let intersection = a.intersection(b)
            #expect(intersection.contains(.sqWakeup))
            #expect(!intersection.contains(.getEvents))
            #expect(!intersection.contains(.sqWait))
        }
    }

    // MARK: - Conformance Tests

    extension Kernel.IO.Uring.Enter.Flags.Test.Unit {
        @Test("Enter.Flags is Sendable")
        func isSendable() {
            let flags: any Sendable = Kernel.IO.Uring.Enter.Flags.getEvents
            #expect(flags is Kernel.IO.Uring.Enter.Flags)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IO.Uring.Enter.Flags.Test.EdgeCase {
        @Test("flags are distinct")
        func flagsDistinct() {
            let flags: [Kernel.IO.Uring.Enter.Flags] = [
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
            let all: Kernel.IO.Uring.Enter.Flags = [
                .getEvents, .sqWakeup, .sqWait, .extArg, .registeredRing,
            ]
            #expect(all.rawValue == 0x1F)
        }
    }
#endif
