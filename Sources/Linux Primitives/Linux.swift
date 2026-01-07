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

/// Linux platform namespace.
///
/// Contains Linux-specific kernel mechanisms including:
/// - epoll event notification
/// - io_uring async I/O
/// - eventfd
public enum Linux: Sendable {}
