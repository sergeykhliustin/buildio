//
//  BuildsScreenTests.swift
//  BuildioUITests
//
//  Created by Sergey Khliustin on 04.12.2022.
//

import XCTest
import SnapshotTesting

final class BuildsScreenTests: XCTestCase {
    func testSnapshotLight() throws {
        let app = appLight()
        app.scrollViews.otherElements.buttons["Demo here"].waitHittable(self).forceTap()
        app.buttons["Builds"].waitHittable(self).forceTap().waitHittable(self)
        assertSnapshot(app: app)
    }

    func testSnapshotDark() throws {
        let app = appDark()
        app.scrollViews.otherElements.buttons["Demo here"].waitHittable(self).forceTap()
        app.buttons["Builds"].waitHittable(self).forceTap().waitHittable(self)
        assertSnapshot(app: app)
    }
}
