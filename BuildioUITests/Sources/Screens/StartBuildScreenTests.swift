//
//  StartBuildScreenTests.swift
//  BuildioUITests
//
//  Created by Sergey Khliustin on 04.12.2022.
//

import XCTest
import SnapshotTesting

final class StartBuildScreenTests: XCTestCase {
    func testInitialSnapshotLight() throws {
        let app = appLight()
        app.scrollViews.otherElements.buttons["Demo here"].waitHittable(self).forceTap()
        app.navigationBars["Builds"].buttons["Add"].waitHittable(self).forceTap()
        app.navigationBars["Start a build"].buttons["Close"].waitHittable(self)
        assertSnapshot(app: app)
    }

    func testInitialSnapshotDark() throws {
        let app = appDark()
        app.scrollViews.otherElements.buttons["Demo here"].waitHittable(self).forceTap()
        app.navigationBars["Builds"].buttons["Add"].waitHittable(self).forceTap()
        app.navigationBars["Start a build"].buttons["Close"].waitHittable(self)
        assertSnapshot(app: app)
    }

    func testAppSelectedSnapshotLight() throws {
        let app = appLight()
        app.scrollViews.otherElements.buttons["Demo here"].waitHittable(self).forceTap()
        app.navigationBars["Builds"].buttons["Add"].waitHittable(self).forceTap()
        app.scrollViews.otherElements.buttons["Select the app"].waitHittable(self).forceTap()
        app.scrollViews.otherElements.buttons["buildio, demo user"].waitHittable(self).forceTap()
        app.navigationBars["Start a build"].buttons["Close"].waitHittable(self)
        assertSnapshot(app: app)
    }

    func testAppSelectedSnapshotDark() throws {
        let app = appDark()
        app.scrollViews.otherElements.buttons["Demo here"].waitHittable(self).forceTap()
        app.navigationBars["Builds"].buttons["Add"].waitHittable(self).forceTap()
        app.scrollViews.otherElements.buttons["Select the app"].waitHittable(self).forceTap()
        app.scrollViews.otherElements.buttons["buildio, demo user"].waitHittable(self).forceTap()
        app.navigationBars["Start a build"].buttons["Close"].waitHittable(self)
        assertSnapshot(app: app)
    }

    func testBranchesSnapshotLight() throws {
        let app = appLight()
        let otherElements: XCUIElementQuery = app.scrollViews.otherElements
        otherElements.buttons["Demo here"].waitHittable(self).forceTap()
        app.navigationBars["Builds"].buttons["Add"].waitHittable(self).forceTap()
        otherElements.buttons["Select the app"].waitHittable(self).forceTap()
        otherElements.buttons["buildio, demo user"].waitHittable(self).forceTap()
        app.navigationBars["Start a build"].buttons["Close"].waitHittable(self)
        let appElementsQuery = otherElements.containing(.staticText, identifier: "App:")
        appElementsQuery.children(matching: .button).matching(identifier: "Forward").element(boundBy: 0).waitHittable(self).forceTap()
        app.navigationBars["Select branch:"].buttons["Start a build"].waitHittable(self)
        assertSnapshot(app: app)
    }

    func testBranchesSnapshotDark() throws {
        let app = appDark()
        let otherElements: XCUIElementQuery = app.scrollViews.otherElements
        otherElements.buttons["Demo here"].waitHittable(self).forceTap()
        app.navigationBars["Builds"].buttons["Add"].waitHittable(self).forceTap()
        otherElements.buttons["Select the app"].waitHittable(self).forceTap()
        otherElements.buttons["buildio, demo user"].waitHittable(self).forceTap()
        app.navigationBars["Start a build"].buttons["Close"].waitHittable(self)
        let appElementsQuery = otherElements.containing(.staticText, identifier: "App:")
        appElementsQuery.children(matching: .button).matching(identifier: "Forward").element(boundBy: 0).waitHittable(self).forceTap()
        app.navigationBars["Select branch:"].buttons["Start a build"].waitHittable(self)
        assertSnapshot(app: app)
    }

//    func testStartBuild() throws {
//
//        let app = XCUIApplication()
//        let scrollViewsQuery = app.scrollViews
//        let elementsQuery = scrollViewsQuery.otherElements
//        elementsQuery.buttons["Demo here"].tap()
//        app.navigationBars["Builds"]/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".otherElements[\"Notifications\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        elementsQuery.buttons["Select the app"].tap()
//        elementsQuery.buttons["buildio, demo user"].tap()
//
//        let appElementsQuery = scrollViewsQuery.otherElements.containing(.staticText, identifier:"App:")
//        appElementsQuery.children(matching: .button).matching(identifier: "Forward").element(boundBy: 0).tap()
//        app.navigationBars["Select branch:"].buttons["Start a build"].tap()
//        appElementsQuery.children(matching: .button).matching(identifier: "Forward").element(boundBy: 1).tap()
//        XCUIApplication().navigationBars["Start a build"]/*@START_MENU_TOKEN@*/.buttons["Close"]/*[[".otherElements[\"Close\"].buttons[\"Close\"]",".buttons[\"Close\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//    }
}
