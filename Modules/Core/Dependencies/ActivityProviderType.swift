//
//  ActivityProviderType.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//
import Foundation

package protocol ActivityProviderType: AnyObject {
    func subscribe() async -> AsyncStream<Date>
}
