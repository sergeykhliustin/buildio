//
//  ActivityProviderMock.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//
import Foundation
import Models

package final class BuildStatusProviderMock: BuildStatusProviderType {
    package init() {}
    package func subscribe(id: ObjectIdentifier, build: Models.BuildResponseItemModel) async -> AsyncStream<Models.BuildResponseItemModel> {
        return AsyncStream { _ in }
    }
}
