//
//  ArtifactRowView.swift
//  
//
//  Created by Sergey Khliustin on 06.12.2021.
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
