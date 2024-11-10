//
//  BuildView.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation
import SwiftUI
import Assets
import MarkdownUI
import Components
import Models

enum MessageStyle {
    case markdown
    case raw
}

struct BuildView: View {
    @Environment(\.theme) private var theme
    let build: BuildResponseItemModel
    @Binding var messageStyle: MessageStyle

    private struct Item: View {
        let image: Images
        let text: String?
        
        var body: some View {
            if let text = text, !text.isEmpty {
                HStack(spacing: 4) {
                    Image(image)
                    TextView("\(text)")
                }
                .primary()
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            let statusColor = build.extendedStatus.color
            Rectangle()
                .fill(statusColor)
                .frame(width: 5)
            
            VStack(alignment: .leading) {
                FlowLayout {
                    Text(build.extendedStatus.rawValue)
                        .foregroundColor(statusColor)
                        .padding(8)
                    HStack(spacing: 4) {
                        Image(.point_topleft_down_curvedto_point_bottomright_up)
                        Text(build.triggeredWorkflow)
                    }
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(theme.borderColor.color))

                    if let pullRequest = build.pullRequestId, pullRequest != 0 {
                        HStack(spacing: 4) {
                            Image(.arrow_triangle_pull)
                            Text(String(pullRequest))
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 4).stroke(Color.fromString(build.branchOrigOwnerUIString)))
                    }

                    Text(build.branchOrigOwnerUIString)
                        .foregroundColor(.white)
                        .padding(8)
                        .lineLimit(3)
                        .background(Color.fromString(build.branchOrigOwnerUIString))
                        .cornerRadius(4)

                    if let targetBranch = build.pullRequestTargetBranch {
                        Image(.arrow_right)
                            .padding(8)

                        Text(targetBranch)
                            .foregroundColor(.white)
                            .padding(8)
                            .lineLimit(3)
                            .background(Color.fromString(targetBranch))
                            .cornerRadius(4)
                    }
                }
                .primary()
                .padding(.top, 2)

                ProgressView(value: build.progress ?? 0)
                    .progressViewStyle(LinearProgressViewStyle())
                
                Group {
                    HStack {
                        TextView("Triggered @ " + build.triggeredAt.full)
                        Spacer()
                        if let progress = build.progress {
                            TextView("\(Int(progress * 100))%")
                        }
                    }
                    .primary()
                    Item(image: .clock, text: build.durationString)
                    Item(image: .coloncurrencysign_circle, text: build.creditCost?.description)
                    Item(image: .number, text: String(build.buildNumber))
                    Item(image: .square_stack_3d_up,
                         text: [build.machineTypeId, build.stackIdentifier].compactMap({ $0 }).joined(separator: " "))
                    Item(image: .bolt_fill, text: build.triggeredBy)
                    
                    Rectangle()
                        .fill(theme.separatorColor.color)
                        .frame(height: 1)
                }
                
                Group {
                    Text("Commit hash:").secondary()
                    TextView(build.commitHash ?? "No commit hash specified").primary()
                    Rectangle().fill(theme.separatorColor.color).frame(height: 1)
                }
                
                Group {
                    HStack {
                        Text("Commit message:")
                        Picker("", selection: $messageStyle) {
                            Text("MD")
                                .primary()
                                .tag(MessageStyle.markdown)
                            Text("TXT")
                                .primary()
                                .tag(MessageStyle.raw)
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                    .secondary()
                    
                    if let commitMessage = build.commitMessage, messageStyle == .markdown {
                        Markdown(commitMessage)
                            .markdownTheme(
                                .init()
                                    .text {
                                        #if targetEnvironment(macCatalyst)
                                        FontSize(11)
                                        #else
                                        FontSize(15)
                                        #endif
                                        ForegroundColor(theme.textColor.color)
                                        BackgroundColor(.clear)
                                    }
                                    .link {
                                        UnderlineStyle(.single)
                                    }
                            )
                            .padding([.top], 1)
                    } else {
                        TextView(build.commitMessage ?? "No commit message")
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .primary()
                    }
                    
                    Rectangle().fill(theme.separatorColor.color).frame(height: 1)
                }
                
                if let abortReason = build.abortReason {
                    Group {
                        Text("Abort reason:").secondary()
                        TextView(abortReason).primary()
                        Rectangle().fill(theme.separatorColor.color).frame(height: 1)
                    }
                }
                
                if let denTags = build.denTags, !denTags.isEmpty {
                    Group {
                        Text("Build tags:").secondary()
                        TextView(denTags.joined(separator: ", ")).primary()
                        Rectangle().fill(theme.separatorColor.color).frame(height: 1)
                    }
                }
                
                if let startedOn = build.startedOnWorkerAt {
                    Group {
                        Text("Started @").secondary()
                        TextView(startedOn.full).primary()
                        Rectangle().fill(theme.separatorColor.color).frame(height: 1)
                    }
                }
                
                if let finishedAt = build.finishedAt {
                    Group {
                        Text("Finished @").secondary()
                        TextView(finishedAt.full).primary()
                        Rectangle().fill(theme.separatorColor.color).frame(height: 1)
                    }
                }

                Group {
                    Text("Build parameters:").secondary()

                    Group {
                        TextView(build.originalBuildParamsString)
                            .primary()
                            .font(.footnote)
                            .lineLimit(nil)
                            .padding(10)
                            .layoutPriority(1)
                    }
                    .cornerRadius(4)
                    .border(theme.borderColor.color, width: 1)
                }
            }
            .padding(.horizontal, 8)
        }
        .multilineTextAlignment(.leading)
    }
}

private struct PrimaryModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
    }
}

private struct SecondaryModifier: ViewModifier {
    @Environment(\.theme) private var theme

    func body(content: Content) -> some View {
        content
            .foregroundColor(theme.textColorLight.color)
            .font(.callout)
    }
}

private extension View {
    func primary() -> some View {
        modifier(PrimaryModifier())
    }
    func secondary() -> some View {
        modifier(SecondaryModifier())
    }
}
