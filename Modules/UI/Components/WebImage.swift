//
//  WebImage.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//
import Foundation
import SwiftUI
import Assets
import Kingfisher

package struct WebImage: View {
    let title: String
    let url: URL?

    package init(title: String, url: String?) {
        self.title = title
        self.url = URL(string: url ?? "")
    }

    package var body: some View {
        if let url = url {
            KFImage(url)
                .placeholder { progress in
                    BuildioProgressView(value: progress.fractionCompleted)
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
//            AsyncImage(url: url) { phase in
//                switch phase {
//                case .empty:
//                    BuildioProgressView()
//                case .success(let image):
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                case .failure:
//                    fallback
//                @unknown default:
//                    EmptyView()
//                }
//            }
        } else {
            fallback
        }
    }

    @ViewBuilder
    private var fallback: some View {
        if !title.isEmpty {
            Text([title.first.map(String.init) ?? "N", title.last.map(String.init) ?? "A"].joined(separator: "").uppercased())
                .foregroundColor(.white)
                .font(.title2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.fromString(title))
        }
    }
}
