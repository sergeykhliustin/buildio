//
//  LoginScreenTests.swift
//  BuildioUITests
//
//  Created by Sergey Khliustin on 04.12.2022.
//

import XCTest
import SnapshotTesting

final class LoginScreenTests: XCTestCase {
    func testSnapshotLight() throws {
        let app = appLight()
        assertSnapshot(app: app)
    }

    func testSnapshotDark() throws {
        let app = appDark()
        assertSnapshot(app: app)
    }
}
