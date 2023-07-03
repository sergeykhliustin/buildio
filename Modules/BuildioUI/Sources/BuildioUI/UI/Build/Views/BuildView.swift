//
//  BuildView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import SwiftUI
import Models
import MarkdownUI
import BuildioLogic

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

extension MarkdownUI.Theme {
    static let buildio = Theme()
        .text {
            #if targetEnvironment(macCatalyst)
            FontSize(11)
            #else
            FontSize(15)
            #endif
            ForegroundColor(Color(light: BuildioLogic.Theme.currentLight.textColor, dark: BuildioLogic.Theme.currentDark.textColor))
            BackgroundColor(.clear)
        }
        .link {
            UnderlineStyle(.single)
        }
}

struct BuildView: View {
    @Environment(\.theme) private var theme
    @State private var messageStyle: MessageStyle = .markdown
    
    private struct Item: View {
        let image: Images
        let text: String?
        
        var body: some View {
            if let text = text, !text.isEmpty {
                HStack(spacing: 4) {
                    Image(image)
                    TextElement("\(text)")
                }
                .primary()
            }
        }
    }
    
    @EnvironmentObject var model: BuildViewModel
    
    var body: some View {
        let build = model.value!
        HStack(alignment: .top, spacing: 0) {
            let statusColor = build.extendedStatus.color
            Rectangle()
                .fill(statusColor)
                .frame(width: 5)
            
            VStack(alignment: .leading) {
                BuildHeaderView(model: build)
                    .primary()
                        
                ProgressView(value: model.progress ?? 0)
                    .progressViewStyle(LinearProgressViewStyle())
                
                Group {
                    HStack {
                        TextElement("Triggered @ " + build.triggeredAt.full)
                        Spacer()
                        if let progress = model.progress {
                            TextElement("\(Int(progress * 100))%")
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
                        .fill(theme.separatorColor)
                        .frame(height: 1)
                }
                
                Group {
                    Text("Commit hash:").secondary()
                    TextElement(build.commitHash ?? "No commit hash specified").primary()
                    Rectangle().fill(theme.separatorColor).frame(height: 1)
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
                            .markdownTheme(.buildio)
                            .padding([.top], 1)
                    } else {
                        TextElement(build.commitMessage ?? "No commit message")
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .primary()
                    }
                    
                    Rectangle().fill(theme.separatorColor).frame(height: 1)
                }
                
                if let abortReason = build.abortReason {
                    Group {
                        Text("Abort reason:").secondary()
                        TextElement(abortReason).primary()
                        Rectangle().fill(theme.separatorColor).frame(height: 1)
                    }
                }
                
                if let denTags = build.denTags, !denTags.isEmpty {
                    Group {
                        Text("Build tags:").secondary()
                        TextElement(denTags.joined(separator: ", ")).primary()
                        Rectangle().fill(theme.separatorColor).frame(height: 1)
                    }
                }
                
                if let startedOn = build.startedOnWorkerAt {
                    Group {
                        Text("Started @").secondary()
                        TextElement(startedOn.full).primary()
                        Rectangle().fill(theme.separatorColor).frame(height: 1)
                    }
                }
                
                if let finishedAt = build.finishedAt {
                    Group {
                        Text("Finished @").secondary()
                        TextElement(finishedAt.full).primary()
                        Rectangle().fill(theme.separatorColor).frame(height: 1)
                    }
                }

                Group {
                    Text("Build parameters:").secondary()

                    Group {
                        TextElement(build.originalBuildParamsString)
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
            .padding(.horizontal, 8)
        }
        .multilineTextAlignment(.leading)
    }
}
