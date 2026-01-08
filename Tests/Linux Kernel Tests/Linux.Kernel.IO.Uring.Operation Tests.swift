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

    extension Kernel.IO.Uring.Operation {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IO.Uring.Operation.Test.Unit {
        @Test("Operation namespace exists")
        func namespaceExists() {
            _ = Kernel.IO.Uring.Operation.self
        }

        @Test("Operation is an enum")
        func isEnum() {
            let _: Kernel.IO.Uring.Operation.Type = Kernel.IO.Uring.Operation.self
        }
    }

    // MARK: - Nested Types

    extension Kernel.IO.Uring.Operation.Test.Unit {
        @Test("Operation.Data type exists")
        func dataTypeExists() {
            let _: Kernel.IO.Uring.Operation.Data.Type = Kernel.IO.Uring.Operation.Data.self
        }
    }
#endif
