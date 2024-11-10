//
//  ActivityProviderMock.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//
import Foundation

package final class ActivityProviderMock: ActivityProviderType {
    package init() {}
    package func subscribe() async -> AsyncStream<Date> {
        return AsyncStream { _ in }
    }
}
