//
//  KeyboardObserver.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 23.11.2021.
//

import Foundation
import Combine
import UIKit

final class KeyboardObserver: ObservableObject {
    @Published var isVisible: Bool = false
    init() {
        NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification).eraseToAnyPublisher().map({ _ in true }).assign(to: &$isVisible)
        NotificationCenter.default.publisher(for: UIApplication.keyboardDidHideNotification).eraseToAnyPublisher().map({ _ in false }).assign(to: &$isVisible)
    }
}
