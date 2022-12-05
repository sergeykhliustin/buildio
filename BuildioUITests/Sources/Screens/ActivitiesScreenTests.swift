//
//  ActivitiesScreenTests.swift
//  BuildioUITests
//
//  Created by Sergey Khliustin on 04.12.2022.
//

import XCTest
import SnapshotTesting

final class ActivitiesScreenTests: XCTestCase {
    func testSnapshotLight() throws {
        let app = appLight()
        app.scrollViews.otherElements.buttons["Demo here"].waitHittable(self).forceTap()
        app.navigationBars["Builds"].buttons["Notifications"].waitHittable(self).forceTap()
        app.navigationBars["Activities"].buttons["Builds"].waitHittable(self)
        assertSnapshot(app: app)
    }

    func testSnapshotDark() throws {
        let app = appDark()
        app.scrollViews.otherElements.buttons["Demo here"].waitHittable(self).forceTap()
        app.navigationBars["Builds"].buttons["Notifications"].waitHittable(self).forceTap()
        app.navigationBars["Activities"].buttons["Builds"].waitHittable(self)
        assertSnapshot(app: app)
    }
}
