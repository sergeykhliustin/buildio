//
//  BuildRowView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import SwiftUI
import Models
import Combine

struct BuildRowView: View {
    @Environment(\.colorScheme.theme) private var theme
    @Binding private var route: Route?
    @StateObject private var viewModel: BuildViewModel
    let showBottomControls: Bool
    
    @State private var abortConfirmation: Bool = false
    @State private var abortReason: String = ""
    
    init(build: BuildResponseItemModel, route: Binding<Route?>, showBottomControls: Bool = true) {
        self.showBottomControls = showBottomControls
        _route = route
        _viewModel = StateObject(wrappedValue: ViewModelResolver.build(build))
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
                    AvatarView(app: model.repository)
                        .frame(width: 40, height: 40)
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 0) {
                            Text(model.repository.title)
                                .font(.footnote.bold())
                            if let tag = model.tag {
                                Spacer()
                                HStack(spacing: 2) {
                                    Image(systemName: "tag")
                                    Text(tag)
                                }
                                .padding(.horizontal, 2)
                            }
                        }
                        HStack(spacing: 0) {
                            Text(model.commitMessage ?? "No commit message")
                            Spacer()
                        }
                    }
                    
                    if viewModel.state == .loading {
                        ProgressView()
                    } else {   
                        Text(model.durationString ?? "")
                    }
                }
                .lineLimit(1)
                .padding(8)
                Rectangle().fill(theme.borderColor)
                    .frame(height: 1)
                HStack(spacing: 0) {
                    Text(model.branchFromToUIString)
                        .truncationMode(.middle)
                        .lineLimit(1)
                        .padding(8)
                        .foregroundColor(extendedStatus.color)
                        .background(extendedStatus.colorLight)
                    if let pullRequestId = model.pullRequestId, pullRequestId != 0 {
                        Text(String(pullRequestId))
                            .padding(8)
                    } else if let commitHash = model.commitHash {
                        Text(String(commitHash.prefix(7)))
                            .padding(8)
                    }
                    Spacer(minLength: 0)
                    if let cost = model.creditCost {
                        Text(String(cost))
                            .padding(8)
                    }
                    Text(model.triggeredWorkflow)
                        .padding(8)
                    Text("#\(String(model.buildNumber))")
                        .padding(8)
                }
                
                Rectangle().fill(theme.borderColor)
                    .frame(height: 1)
                if showBottomControls {
                    HStack(spacing: 8) {
                        Button(action: {
                            route = .logs(model)
                        }, label: {
                            Image(systemName: "note.text")
                            Text("Logs")
                        })
                            .buttonStyle(BorderButtonStyle(padding: 2))
                        if model.status == .running {
                            Spacer()
                            Button(action: {
                                abortConfirmation = true
                            }, label: {
                                Image(systemName: "nosign")
                                Text("Abort")
                            })
                                .buttonStyle(BorderButtonStyle(padding: 2))
                        } else {
                            Spacer()
                            Button(action: {
                                route = .artifacts(model)
                            }, label: {
                                Image(systemName: "archivebox")
                                Text("Apps & Artifacts")
                            })
                                .buttonStyle(BorderButtonStyle(padding: 2))
                            
                            Spacer()
                            Button(action: {
                                viewModel.rebuild()
                            }, label: {
                                Image(systemName: "hammer")
                                Text("Rebuild")
                            })
                                .buttonStyle(BorderButtonStyle(padding: 2))
                        }
                    }
                    .padding(2)
                }
                Group {
                    
                }
                .alert(isPresented: $abortConfirmation, AlertConfig.abort({ viewModel.abort(reason: $0) }))
                .frame(width: 0, height: 0)
                
                if let progress = viewModel.progress {
                    ProgressView(value: progress)
                        .progressViewStyle(.linear)
                }
            }
        }
        .alert(item: $viewModel.actionError, content: { error in
            Alert(title: Text(error.title), message: Text(error.message))
        })
        .font(.footnote)
        .multilineTextAlignment(.leading)
    }
}

struct BuildRowView_Previews: PreviewProvider {
    static var previews: some View {
        BuildRowView(build: BuildResponseItemModel.preview(), route: .constant(nil))
            .preferredColorScheme(.light)
            .padding(8)
            
    }
}
