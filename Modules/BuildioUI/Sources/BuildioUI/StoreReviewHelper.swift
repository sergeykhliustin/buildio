//
//  StoreReviewHelper.swift
//  
//
//  Created by Sergey Khliustin on 21.03.2022.
//

import Foundation
import BuildioLogic
import StoreKit

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
        SKStoreReviewController.requestReview()
    }

    private static func factorial(_ number: Int) -> Int {
        if number == 0 {
            return 1
        }
        var sum: Int = 1
        for index in 1...number {
            sum *= index
        }
        return sum
    }
}
