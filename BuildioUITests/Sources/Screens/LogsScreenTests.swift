//
//  LogsScreenTests.swift
//  BuildioUITests
//
//  Created by Sergey Khliustin on 04.12.2022.
//

import XCTest
import SnapshotTesting

final class LogsScreenTests: XCTestCase {
    func testSnapshotLight() throws {
        let app = appLight()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Demo here"].waitHittable(self).forceTap()
        elementsQuery.buttons["buildio, No commit message, 14m 29s, main, 25, deploy_all, 113"].waitHittable(self).forceTap()
        elementsQuery.buttons["Logs"].waitHittable(self).forceTap()
        app.navigationBars["Build #113 logs"].buttons["Build #113"].waitHittable(self)
        assertSnapshot(app: app)
    }

    func testSnapshotDark() throws {
        let app = appDark()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Demo here"].waitHittable(self).forceTap()
        elementsQuery.buttons["buildio, No commit message, 14m 29s, main, 25, deploy_all, 113"].waitHittable(self).forceTap()
        elementsQuery.buttons["Logs"].waitHittable(self).forceTap()
        app.navigationBars["Build #113 logs"].buttons["Build #113"].waitHittable(self)
        assertSnapshot(app: app)
    }
}
