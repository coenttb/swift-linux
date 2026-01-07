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
    #if canImport(Glibc)
        import Glibc
    #elseif canImport(Musl)
        import Musl
    #endif
    import StandardsTestSupport
    import Testing

    import Kernel_Primitives
@testable import Linux_Kernel
    import Kernel_Primitives

    extension Kernel.IOUring {
        #TestSuites
    }

    // MARK: - Syscall Unit Tests

    extension Kernel.IOUring.Test.Unit {

        @Test("isSupported returns boolean")
        func isSupportedReturnsBool() {
            // This should return a boolean without crashing
            let supported = Kernel.IOUring.isSupported
            // Just verify it's a boolean (can be either true or false depending on kernel)
            #expect(supported == true || supported == false)
        }

        @Test("setup returns descriptor and updates params")
        func setupReturnsDescriptorAndUpdatesParams() throws {
            try #require(Kernel.IOUring.isSupported)

            var params = Kernel.IOUring.Params()
            let fd = try Kernel.IOUring.setup(entries: 1, params: &params)
            defer { Kernel.IOUring.close(fd) }

            #expect(fd.rawValue >= 0)
            // Kernel should have updated sqEntries
            #expect(params.sqEntries > 0)
        }

        @Test("enter with zero submit returns immediately")
        func enterWithZeroReturnsImmediately() throws {
            try #require(Kernel.IOUring.isSupported)

            var params = Kernel.IOUring.Params()
            let fd = try Kernel.IOUring.setup(entries: 1, params: &params)
            defer { Kernel.IOUring.close(fd) }

            // Enter with nothing to submit or wait for should return immediately
            let result = try Kernel.IOUring.enter(fd, toSubmit: 0, minComplete: 0, flags: [])
            #expect(result >= 0)
        }

        @Test("close does not crash")
        func closeDoesNotCrash() throws {
            try #require(Kernel.IOUring.isSupported)

            var params = Kernel.IOUring.Params()
            let fd = try Kernel.IOUring.setup(entries: 1, params: &params)

            // Close should not throw (it's non-throwing)
            Kernel.IOUring.close(fd)

            // Double close should also not crash
            Kernel.IOUring.close(fd)
        }

        @Test("setup with invalid entries throws")
        func setupWithInvalidEntriesThrows() throws {
            try #require(Kernel.IOUring.isSupported)

            var params = Kernel.IOUring.Params()

            // 0 entries should fail
            #expect(throws: Kernel.IOUring.Error.self) {
                _ = try Kernel.IOUring.setup(entries: 0, params: &params)
            }
        }
    }

#endif
