//
//  Setup.swift
//  BuildioUITests
//
//  Created by Sergey Khliustin on 29.04.2024.
//

import Foundation
import SnapshotTesting

final class Setup: NSObject {
    override init() {
        SnapshotTesting.diffTool = "ksdiff"
    }
}
