//
//  BuildView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import SwiftUI
import Models

private struct PrimaryModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.b_TextBlack)
            .font(.subheadline)
    }
}

private struct SecondaryModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.b_TextBlackLight)
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

struct BuildView: View {
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
            let statusColor = model.color
            Rectangle()
                .fill(statusColor)
                .frame(width: 5)

            let statusText = model.isOnHold ? "On hold" : model.environmentPrepareFinishedAt == nil ? "Waiting for worker" : model.status.text
            
            VStack(alignment: .leading) {
                Group {
                    TagView(spacing: 4, content: { [
                        AnyView(
                            Text(statusText)
                                .foregroundColor(statusColor)
                                .padding(8)
                        ),
                        
                        AnyView(
                            Group {
                                Text(model.branch)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .lineLimit(1)
                            }
                                .background(Color.fromString(model.branch))
                                .cornerRadius(4)
                        ),
                        
                        AnyView(
                            Text(model.triggeredWorkflow)
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: 4).stroke(Color.b_BorderLight))
                        )
                    ]
                    })
                        .font(.subheadline)
                        .padding(.top, 4)
                    
                    ProgressView(value: progress ?? 0)
                        .progressViewStyle(.linear)
                }
                
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
                        .fill(Color.b_BorderLight)
                        .frame(height: 1)
                }
                
                Group {
                    Text("Commit hash:").secondary()
                    Text(model.commitHash ?? "No commit hash specified").primary()
                    Rectangle().fill(Color.b_BorderLight).frame(height: 1)
                }
                
                Group {
                    Text("Commit message:").secondary()
                    Text(model.commitMessage ?? "No commit message").primary()
                    Rectangle().fill(Color.b_BorderLight).frame(height: 1)
                }
                
                if let abortReason = model.abortReason {
                    Group {
                        Text("Abort reason:").secondary()
                        Text(abortReason).primary()
                        Rectangle().fill(Color.b_BorderLight).frame(height: 1)
                    }
                }
                
                if let denTags = model.denTags, !denTags.isEmpty {
                    Group {
                        Text("Build tags:").secondary()
                        Text(denTags.joined(separator: ", ")).primary()
                        Rectangle().fill(Color.b_BorderLight).frame(height: 1)
                    }
                }
                
                if let startedOn = model.startedOnWorkerAt {
                    Group {
                        Text("Started @").secondary()
                        Text(startedOn.full).primary()
                        Rectangle().fill(Color.b_BorderLight).frame(height: 1)
                    }
                }
                
                if let finishedAt = model.finishedAt {
                    Group {
                        Text("Finished @").secondary()
                        Text(finishedAt.full).primary()
                        Rectangle().fill(Color.b_BorderLight).frame(height: 1)
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
                        .border(Color(red: 0.84, green: 0.84, blue: 0.84), width: 1)
                        .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                        .cornerRadius(4)
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
