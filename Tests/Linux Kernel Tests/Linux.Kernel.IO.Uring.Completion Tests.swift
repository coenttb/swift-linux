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

    extension Kernel.IO.Uring.Completion {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IO.Uring.Completion.Test.Unit {
        @Test("Completion namespace exists")
        func namespaceExists() {
            _ = Kernel.IO.Uring.Completion.self
        }

        @Test("Completion is an enum")
        func isEnum() {
            let _: Kernel.IO.Uring.Completion.Type = Kernel.IO.Uring.Completion.self
        }
    }

    // MARK: - Nested Types

    extension Kernel.IO.Uring.Completion.Test.Unit {
        @Test("Completion.Queue type exists")
        func queueTypeExists() {
            let _: Kernel.IO.Uring.Completion.Queue.Type = Kernel.IO.Uring.Completion.Queue.self
        }
    }
#endif
