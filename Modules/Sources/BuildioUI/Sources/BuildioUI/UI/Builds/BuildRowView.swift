//
//  BuildRowView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import SwiftUI
import Models
import Combine
import BuildioLogic

struct BuildRowView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var screenFactory: ScreenFactory
    @Environment(\.theme) private var theme
    
    @EnvironmentObject var viewModel: BuildViewModel
    
    @State private var abortConfirmation: Bool = false
    @State private var abortReason: String = ""

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
                            .padding(4)
                    }
                    Text("\(text)")
                }
            }
        }
    }
    
    var body: some View {
        let model = viewModel.value!
        HStack(alignment: .top, spacing: 0) {
            let extendedStatus = model.extendedStatus
            Rectangle()
                .fill(extendedStatus.color)
                .frame(width: 5)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 8) {
                    screenFactory
                        .avatarView(app: model.repository)
                        .frame(width: 40, height: 40)
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 0) {
                            Text(model.repository.title)
                                .font(.footnote.bold())
                            if let tag = model.tag, !tag.isEmpty {
                                Spacer()
                                HStack(spacing: 2) {
                                    Image(.tag)
                                    Text(tag)
                                }
                                .padding(.horizontal, 2)
                            }
                        }
                        HStack(spacing: 0) {
                            Text(model.commitMessage ?? "No commit message")
                            Spacer()
                            if viewModel.state == .loading {
                                ProgressView()
                                    .frame(width: 15, height: 15, alignment: .center)
                            } else {
                                Item(image: .system(.clock), text: model.durationString)
                            }
                        }
                    }
                }
                .lineLimit(1)
                .padding(8)
                Rectangle().fill(theme.separatorColor)
                    .frame(height: 1)
                HStack(spacing: 8) {
                    Text(model.branchFromToUIString)
                        .truncationMode(.middle)
                        .lineLimit(1)
                        .padding(8)
                        .foregroundColor(extendedStatus.color)
                        .background(extendedStatus.colorLight)
                    if let pullRequestId = model.pullRequestId, pullRequestId != 0 {
                        Item(image: .system(.arrow_triangle_pull), text: String(pullRequestId))
                    } else if let commitHash = model.commitHash {
                        Item(image: .custom("github"), text: String(commitHash.prefix(7)))
                    }
                    Spacer(minLength: -2)
                    Item(image: .system(.coloncurrencysign_circle), text: model.creditCost?.description)
                    Item(image: .system(.point_topleft_down_curvedto_point_bottomright_up), text: model.triggeredWorkflow)
                        .truncationMode(.middle)
                        .lineLimit(1)
                    Item(image: .system(.number), text: String(model.buildNumber))
                }
                .padding(.trailing, 8)
                
                Group {
                    
                }
                .alert(isPresented: $abortConfirmation, AlertConfig.abort({ viewModel.abort(reason: $0) }))
                .frame(width: 0, height: 0)
                
                if let progress = viewModel.progress {
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                } else {
                    Rectangle().fill(theme.separatorColor)
                        .frame(height: 1)
                }
            }
        }
        .alert(item: $viewModel.actionError, content: { error in
            Alert(title: Text(error.title), message: Text(error.message))
        })
        .font(.footnote)
        .multilineTextAlignment(.leading)
        .background(theme.background)
        .contextMenu {
            Button(action: {
                navigator.go(.logs(model), replace: true)
            }, label: {
                Image(.note_text)
                Text("Logs")
            })
            
            if model.status == .running {
                Button(action: {
                    abortConfirmation = true
                }, label: {
                    Image(.nosign)
                    Text("Abort")
                })
            } else {
                Button(action: {
                    navigator.go(.artifacts(model), replace: true)
                }, label: {
                    Image(.archivebox)
                    Text("Artifacts")
                })
                
                Button(action: {
                    viewModel.rebuild()
                }, label: {
                    Image(.hammer)
                    Text("Rebuild")
                })
            }
        }
    }
}
