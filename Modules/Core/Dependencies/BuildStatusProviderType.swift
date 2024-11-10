//
//  BuildStatusProviderType.swift
//  Modules
//
//  Created by Sergii Khliustin on 06.11.2024.
//

import Foundation
import Models

package protocol BuildStatusProviderType: AnyObject {
    func subscribe(id: ObjectIdentifier, build: BuildResponseItemModel) async -> AsyncStream<BuildResponseItemModel>
}
