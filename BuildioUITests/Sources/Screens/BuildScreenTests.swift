//
//  BuildScreenTests.swift
//  BuildioUITests
//
//  Created by Sergey Khliustin on 04.12.2022.
//

import XCTest
import SnapshotTesting

final class BuildScreenTests: XCTestCase {
    func testSuccessSnapshotLight() throws {
        let app = appLight()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Demo here"].waitHittable(self).forceTap()
        elementsQuery.buttons["buildio, No commit message, 14m 29s, main, 25, deploy_all, 113"].waitHittable(self).forceTap()
        elementsQuery.buttons["🚀 Rebuild"].waitHittable(self)
        assertSnapshot(app: app)
    }

    func testSuccessSnapshotDark() throws {
        let app = appDark()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Demo here"].waitHittable(self).forceTap()
        elementsQuery.buttons["buildio, No commit message, 14m 29s, main, 25, deploy_all, 113"].waitHittable(self).forceTap()
        elementsQuery.buttons["🚀 Rebuild"].waitHittable(self)
        assertSnapshot(app: app)
    }

    func testFailedSnapshotLight() {
        let app = appLight()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Demo here"].waitHittable(self).forceTap()
        elementsQuery.buttons["buildio, No commit message, main, 24, deploy_all, 111"].waitHittable(self).forceTap()
        elementsQuery.buttons["🚀 Rebuild"].waitHittable(self)
        assertSnapshot(app: app)
    }

    func testFailedSnapshotDark() {
        let app = appDark()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Demo here"].waitHittable(self).forceTap()
        elementsQuery.buttons["buildio, No commit message, main, 24, deploy_all, 111"].waitHittable(self).forceTap()
        elementsQuery.buttons["🚀 Rebuild"].waitHittable(self)
        assertSnapshot(app: app)
    }

    func testAbortedSnapshotLight() {
        let app = appLight()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Demo here"].waitHittable(self).forceTap()
        elementsQuery.buttons["buildio, No commit message, main, 2, deploy_all, 110"].waitHittable(self).forceTap()
        elementsQuery.buttons["🚀 Rebuild"].waitHittable(self)
        assertSnapshot(app: app)
    }

    func testAbortedSnapshotDark() {
        let app = appDark()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Demo here"].waitHittable(self).forceTap()
        elementsQuery.buttons["buildio, No commit message, main, 2, deploy_all, 110"].waitHittable(self).forceTap()
        elementsQuery.buttons["🚀 Rebuild"].waitHittable(self)
        assertSnapshot(app: app)
    }
}
