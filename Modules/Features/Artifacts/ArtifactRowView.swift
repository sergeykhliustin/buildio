//
//  ArtifactRowView.swift
//  Modules
//
//  Created by Sergii Khliustin on 10.11.2024.
//

import SwiftUI
import Models

struct ArtifactRowView: View {
    let value: V0ArtifactListElementResponseModel
    var body: some View {
        HStack(spacing: 0) {
            Text(value.title ?? "")
                .padding(8)
            Spacer()
        }
    }
}
