//
//  WebFlowPageModel.swift
//  Modules
//
//  Created by Sergii Khliustin on 12.11.2024.
//

import Foundation
import UITypes
import Dependencies
import UIKit

package final class WebFlowPageModel: PageModelType {
    let url: URL
    @Published var progress: Double = 0

    package init(dependencies: DependenciesType, url: URL) {
        self.url = url
        super.init(dependencies: dependencies)
    }

    func onExternalBrowser() {
        UIApplication.shared.open(url)
    }
}
