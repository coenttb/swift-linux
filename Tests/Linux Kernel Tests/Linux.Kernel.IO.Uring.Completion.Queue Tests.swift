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

    extension Kernel.IO.Uring.Completion.Queue {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IO.Uring.Completion.Queue.Test.Unit {
        @Test("Queue namespace exists")
        func namespaceExists() {
            _ = Kernel.IO.Uring.Completion.Queue.self
        }

        @Test("Queue is an enum")
        func isEnum() {
            let _: Kernel.IO.Uring.Completion.Queue.Type = Kernel.IO.Uring.Completion.Queue.self
        }
    }

    // MARK: - Nested Types

    extension Kernel.IO.Uring.Completion.Queue.Test.Unit {
        @Test("Queue.Entry type exists")
        func entryTypeExists() {
            let _: Kernel.IO.Uring.Completion.Queue.Entry.Type = Kernel.IO.Uring.Completion.Queue.Entry.self
        }

        @Test("Queue.Offsets type exists")
        func offsetsTypeExists() {
            let _: Kernel.IO.Uring.Completion.Queue.Offsets.Type = Kernel.IO.Uring.Completion.Queue.Offsets.self
        }
    }
#endif
