//
//  BuildRowView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import SwiftUI
import Models
import Assets

package struct BuildRowView: View {
    @Environment(\.theme) private var theme
    let model: BuildResponseItemModel
    let isLoading: Bool

    package init(model: BuildResponseItemModel, isLoading: Bool) {
        self.model = model
        self.isLoading = isLoading
    }

    enum ImageType {
        case system(Images)
        case custom(String)
    }

    private struct Item: View {
        let image: ImageType
        let text: String?

        init(image: ImageType, text: String?) {
            self.image = image
            self.text = text
        }

        var body: some View {
            if let text = text, !text.isEmpty {
                HStack(spacing: 0) {
                    switch image {
                    case .system(let image):
                        Image(image)
                    case .custom(let imageName):
                        Image(imageName)
                            .renderingMode(.template)
                            .padding(.horizontal, 2)
                    }
                    Text("\(text)")
                }
            }
        }
    }

    package var body: some View {
        HStack(alignment: .top, spacing: 0) {
            let extendedStatus = model.extendedStatus
            Rectangle()
                .fill(extendedStatus.color)
                .frame(width: 5)

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 8) {
                    WebImage(title: model.repository.title, url: model.repository.avatarUrl)
                        .frame(width: 40, height: 40)
                        .rounded(radius: 8)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 0) {
                            Text(model.repository.title)
                                .font(.footnote.bold())
                            Spacer()
                            Item(image: .system(.clock), text: model.durationString)
                        }
                        HStack(spacing: 0) {
                            Text(model.commitMessage ?? "No commit message")
                                .lineLimit(3)
                            Spacer()
                            if isLoading {
                                BuildioProgressView()
                                    .frame(width: 15, height: 15, alignment: .center)
                            }
                        }
                    }
                }
                .lineLimit(1)
                .padding(8)
                Rectangle().fill(theme.separatorColor.color)
                    .frame(height: 1)
                FlowLayout(horizontalSpacing: 0, verticalSpacing: 0) {
                    Group {
                        if let pullRequestTargetBranch = model.pullRequestTargetBranch, let branch = model.branch {
                            Text("\(branch)")
                                .padding(8)
                            Text("→")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 2)
                            Text("\(pullRequestTargetBranch)")
                                .padding(8)
                        } else if let branch = model.branch, !branch.isEmpty {
                            Text(branch)
                                .padding(8)
                        } else if let tag = model.tag, !tag.isEmpty {
                            HStack(spacing: 2) {
                                Image(.tag)
                                Text(tag)
                            }
                            .padding(8)
                        }
                    }
                    .truncationMode(.middle)
                    .lineLimit(1)
                    .foregroundColor(extendedStatus.color)
                    .background(extendedStatus.colorLight)

                    Group {
                        if let pullRequestId = model.pullRequestId, pullRequestId != 0 {
                            Item(image: .system(.arrow_triangle_pull), text: String(pullRequestId))
                        } else if let commitHash = model.commitHash {
                            Item(image: .custom("github"), text: String(commitHash.prefix(7)))
                        }
                        Item(
                            image: .system(.coloncurrencysign_circle),
                            text: model.creditCost?.description
                        )
                        Item(
                            image: .system(.point_topleft_down_curvedto_point_bottomright_up),
                            text: model.triggeredWorkflow
                        )
                        .truncationMode(.middle)
                        .lineLimit(1)
                        Item(image: .system(.number), text: String(model.buildNumber))
                    }
                    .padding(8)
                }
                .padding(.trailing, 8)

                if let progress = model.progress {
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                } else {
                    Rectangle().fill(theme.separatorColor.color)
                        .frame(height: 1)
                }
            }
        }
        .font(.footnote)
        .multilineTextAlignment(.leading)
        .background(theme.background.color)
        .id(model.id)
    }
}

#Preview {
    BuildRowView(
        model: .preview(),
        isLoading: false
    )
}
