//
//  Shared.swift
//  BuildioUITests
//
//  Created by Sergey Khliustin on 04.12.2022.
//

import Foundation
import SnapshotTesting
import XCTest
import BuildioLogic

func appLight() -> XCUIApplication {
    let app = XCUIApplication()
    app.launchEnvironment = [
        ProcessInfo.Keys.OverrideInterfaceStyle.rawValue: "light",
        ProcessInfo.Keys.TestsMode.rawValue: "true"
    ]
    XCUIDevice.shared.orientation = .portrait
    app.launch()
    return app
}

func appDark() -> XCUIApplication {
    let app = XCUIApplication()
    app.launchEnvironment = [
        ProcessInfo.Keys.OverrideInterfaceStyle.rawValue: "dark",
        ProcessInfo.Keys.TestsMode.rawValue: "true"
    ]
    XCUIDevice.shared.orientation = .portrait
    app.launch()
    return app
}

extension XCUIElement {
    @discardableResult
    func waitForExistance() -> Bool {
        return waitForExistence(timeout: 1.0)
    }

    func wait() -> Self {
        self.waitForExistance()
        return self
    }

    @discardableResult
    func waitHittable(_ testCase: XCTestCase) -> Self {
        let expectation = testCase.expectation(for: NSPredicate(format: "isHittable == true"), evaluatedWith: self)
        let result = XCTWaiter.wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(result, .completed)

        return self
    }

    @discardableResult
    func forceTap() -> Self {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        }

        return self
    }
}

extension XCTActivity {
    func assertSnapshot(app: XCUIApplication,
                        file: StaticString = #file,
                        testName: String = #function,
                        line: UInt = #line) {
        guard let image = app.windows.firstMatch.screenshot().image.removingBottomBar else { return }
        let view = UIImageView(image: image)
        SnapshotTesting.assertSnapshot(matching: view, as: .image(perceptualPrecision: 0.92), file: file, testName: testName, line: line)
    }
}

private extension UIImage {
    var removingBottomBar: UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }

        let yOffset = 20 * scale // status bar height on standard devices (not iPhoneX)
        let rect = CGRect(
            x: 0,
            y: 0,
            width: cgImage.width,
            height: cgImage.height - Int(yOffset)
        )

        if let croppedCGImage = cgImage.cropping(to: rect) {
            return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
        }

        return nil
    }
    var removingStatusBar: UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }

        let yOffset = 54 * scale // status bar height on standard devices (not iPhoneX)
        let rect = CGRect(
            x: 0,
            y: Int(yOffset),
            width: cgImage.width,
            height: cgImage.height - Int(yOffset)
        )

        if let croppedCGImage = cgImage.cropping(to: rect) {
            return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
        }

        return nil
    }
}
