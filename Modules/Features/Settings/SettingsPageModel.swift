//
//  SettingsPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 08.11.2024.
//

import Foundation
import UITypes
import Dependencies
import Components

package final class SettingsPageModel: PageModelType {
    @AppStorageCodable(Settings.key) var settings = Settings() {
        willSet {
            self.objectWillChange.send()
        }
    }
}
