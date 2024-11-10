//
//  PageType.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

import Foundation
import SwiftUI
import Components

@MainActor
package protocol PageType: View {
    associatedtype Model: PageModelType
    associatedtype Content: View

    var viewModel: Model { get }
    init(viewModel: Model)

    @ViewBuilder
    var content: Content { get }
}

package extension PageType {
    var body: some View {
        content
            .overlay(alignment: .top) {
                if let error = viewModel.error {
                    ErrorView(error: error)
                        .transition(.opacity)
                        .zIndex(1)
                        .onTapGesture {
                            viewModel.error = nil
                        }
                }
            }
            .id(viewModel.id)
    }
}
