//
//  Task.swift
//  rawr.
//
//  Created by Nila on 27.11.2023.
//

import Foundation

extension Task where Failure == Error {
    static func delayed(
        _ delayInterval: TimeInterval,
        priority: TaskPriority? = nil,
        operation: @escaping @Sendable () async throws -> Success
    ) -> Task {
        Task(priority: priority) {
            let delay = UInt64(delayInterval * 1_000_000_000)
            try await Task<Never, Never>.sleep(nanoseconds: delay)
            return try await operation()
        }
    }
}
