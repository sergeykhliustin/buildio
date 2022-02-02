//
//  BuildView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import SwiftUI
import Models
import MarkdownUI

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
            .foregroundColor(theme.textColorLight)
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

extension Int: Identifiable {
    public var id: Int {
        return self
    }
}

private enum MessageStyle {
    case markdown
    case raw
}

struct BuildView: View {
    @Environment(\.theme) private var theme
    @State private var messageStyle: MessageStyle = .markdown
    
    private struct Item: View {
        let imageName: String
        let text: String?
        
        var body: some View {
            if let text = text, !text.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: imageName)
                    Text("\(text)")
                }
                .primary()
            }
        }
    }
    
    let model: BuildResponseItemModel
    let progress: Double?
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            let statusColor = model.extendedStatus.color
            Rectangle()
                .fill(statusColor)
                .frame(width: 5)
            
            VStack(alignment: .leading) {
                BuildHeaderView(model: model)
                    .primary()
                        
                ProgressView(value: progress ?? 0)
                    .progressViewStyle(LinearProgressViewStyle())
                
                Group {
                    HStack {
                        Text("Triggered @ " + model.triggeredAt.full)
                        Spacer()
                        if let progress = progress {
                            Text("\(Int(progress * 100))%")
                        }
                    }
                    .primary()
                    Item(imageName: "clock", text: model.durationString)
                    Item(imageName: "coloncurrencysign.circle", text: model.creditCost?.description)
                    Item(imageName: "number", text: String(model.buildNumber))
                    Item(imageName: "square.stack.3d.up",
                         text: [model.machineTypeId, model.stackIdentifier].compactMap({ $0 }).joined(separator: " "))
                    Item(imageName: "bolt.fill", text: model.triggeredBy)
                    
                    Rectangle()
                        .fill(theme.separatorColor)
                        .frame(height: 1)
                }
                
                Group {
                    Text("Commit hash:").secondary()
                    Text(model.commitHash ?? "No commit hash specified").primary()
                    Rectangle().fill(theme.separatorColor).frame(height: 1)
                }
                
                Group {
                    HStack {
                        Text("Commit message:")
                        Picker("", selection: $messageStyle) {
                            Text("MD")
                                .tag(MessageStyle.markdown)
                            Text("TXT")
                                .tag(MessageStyle.raw)
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                    .secondary()
                    
                    if let commitMessage = model.commitMessage, messageStyle == .markdown {
                        Markdown(commitMessage)
                            .markdownStyle(
                                MarkdownStyle(
                                    font: .subheadline,
                                    foregroundColor: MarkdownStyle.Color(uiColor: theme.textColor.uiColor)
                                )
                            )
                    } else {
                        Text(model.commitMessage ?? "No commit message").primary()
                    }
                    
                    Rectangle().fill(theme.separatorColor).frame(height: 1)
                }
                
                if let abortReason = model.abortReason {
                    Group {
                        Text("Abort reason:").secondary()
                        Text(abortReason).primary()
                        Rectangle().fill(theme.separatorColor).frame(height: 1)
                    }
                }
                
                if let denTags = model.denTags, !denTags.isEmpty {
                    Group {
                        Text("Build tags:").secondary()
                        Text(denTags.joined(separator: ", ")).primary()
                        Rectangle().fill(theme.separatorColor).frame(height: 1)
                    }
                }
                
                if let startedOn = model.startedOnWorkerAt {
                    Group {
                        Text("Started @").secondary()
                        Text(startedOn.full).primary()
                        Rectangle().fill(theme.separatorColor).frame(height: 1)
                    }
                }
                
                if let finishedAt = model.finishedAt {
                    Group {
                        Text("Finished @").secondary()
                        Text(finishedAt.full).primary()
                        Rectangle().fill(theme.separatorColor).frame(height: 1)
                    }
                }
                
                if let params = model.originalBuildParamsString {
                    Group {
                        Text("Build parameters:").secondary()
                        
                        Group {
                            Text(params)
                                .primary()
                                .font(.footnote)
                                .lineLimit(nil)
                                .padding(10)
                                .layoutPriority(1)
                        }
                        .cornerRadius(4)
                        .border(theme.borderColor, width: 1)
                        
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .multilineTextAlignment(.leading)
    }
}

struct BuildView_Previews: PreviewProvider {
    static var previews: some View {
        BuildView(model: BuildResponseItemModel.preview(), progress: 0.99)
            .preferredColorScheme(.light)
            
    }
}
