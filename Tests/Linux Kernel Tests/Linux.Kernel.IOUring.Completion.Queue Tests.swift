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

    extension Kernel.IOUring.Completion.Queue {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IOUring.Completion.Queue.Test.Unit {
        @Test("Queue namespace exists")
        func namespaceExists() {
            _ = Kernel.IOUring.Completion.Queue.self
        }

        @Test("Queue is an enum")
        func isEnum() {
            let _: Kernel.IOUring.Completion.Queue.Type = Kernel.IOUring.Completion.Queue.self
        }
    }

    // MARK: - Nested Types

    extension Kernel.IOUring.Completion.Queue.Test.Unit {
        @Test("Queue.Entry type exists")
        func entryTypeExists() {
            let _: Kernel.IOUring.Completion.Queue.Entry.Type = Kernel.IOUring.Completion.Queue.Entry.self
        }

        @Test("Queue.Offsets type exists")
        func offsetsTypeExists() {
            let _: Kernel.IOUring.Completion.Queue.Offsets.Type = Kernel.IOUring.Completion.Queue.Offsets.self
        }
    }
#endif
