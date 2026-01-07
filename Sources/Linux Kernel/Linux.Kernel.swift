// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-linux open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-linux project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Kernel_Primitives
public import Linux_Primitives

extension Linux_Primitives.Linux {
    /// Linux kernel mechanisms.
    ///
    /// This is a typealias to `Kernel_Primitives.Kernel`, allowing Linux-specific
    /// extensions to be added to the shared Kernel type.
    ///
    /// Linux-specific syscall wrappers for:
    /// - epoll event notification
    /// - io_uring async I/O
    /// - eventfd
    /// - copy_file_range, ficlone
    public typealias Kernel = Kernel_Primitives.Kernel
}
