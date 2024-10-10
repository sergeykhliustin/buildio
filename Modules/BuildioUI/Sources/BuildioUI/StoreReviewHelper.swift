//
//  StoreReviewHelper.swift
//  
//
//  Created by Sergey Khliustin on 21.03.2022.
//

import Foundation
import BuildioLogic
import StoreKit
import SwiftUI

public struct StoreReviewHelper {
    public static func appDidBecomeActive() {
        Self.incrementAppOpenedCount()
        Self.checkAndAskForReview()
    }
    
    private static func incrementAppOpenedCount() {
        guard !ProcessInfo.processInfo.isTestEnv else { return }
        UserDefaults.standard.appOpenCount += 1
    }

    private static func checkAndAskForReview() {
        let reviewRequestCount = UserDefaults.standard.reviewRequestCount
        let appOpenCount = UserDefaults.standard.appOpenCount

        let nextlevel = 10 * (StoreReviewHelper.factorial(reviewRequestCount + 1))
        if appOpenCount > nextlevel {
            StoreReviewHelper().requestReview()
            UserDefaults.standard.reviewRequestCount += 1
            UserDefaults.standard.appOpenCount = 0
        }

    }

    private func requestReview() {
        guard !ProcessInfo.processInfo.isTestEnv else { return }
        
        if let scene = UIApplication.shared.windowScene {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }

    private static func factorial(_ number: Int) -> Int {
        if number == 0 {
            return 1
        } else {
            return (1...number).reduce(into: 1) { $0 *= $1 }
        }
    }
}
