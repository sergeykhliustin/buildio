//
//  ErrorView.swift
//
//
//  Created by Sergii Khliustin on 16.05.2024.
//

import Foundation
import SwiftUI
import Assets
import API

struct ErrorView: View {
    @Environment(\.theme) private var theme
    let error: Error?

    private var text: String {
        guard let error else { return "" }
        if let error = error as? ErrorResponse {
            return error.rawErrorString
        } else {
            return error.localizedDescription
        }
    }

    var body: some View {
        Text(text)
            .lineLimit(10)
            .foregroundStyle(theme.errorText.color)
            .font(.body)
            .padding(8)
            .background(theme.errorBackground.color)
            .cornerRadius(8)
    }
}

#Preview {
    ErrorView(error: NSError(domain: "com.buildio", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error description"]))
}
