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
    @Binding var model: BuildResponseItemModel
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>!
    @State private var durationString: String?
    
    init(model: Binding<BuildResponseItemModel>) {
        _model = model
        if model.wrappedValue.status == .running {
            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        }
        _durationString = State(initialValue: model.wrappedValue.durationString)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            let statusColor = model.status.color
            Rectangle()
                .fill(statusColor)
                .frame(width: 5)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    AvatarView(app: model.repository)
                        .frame(width: 40, height: 40)
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text(model.repository.title)
                            .font(.footnote.bold())
                        HStack(spacing: 0) {
                            Text(model.commitMessage ?? "No commit message")
                            if let tag = model.tag {
                                Text(tag)
                                    .padding(2)
                                    .background(Color.b_BorderLight)
                            }
                        }
                    }
                    Spacer()
                    if model.status == .running {
                        Text(durationString ?? "")
                            .onReceive(timer) { _ in
                                durationString = model.durationString
                            }
                    } else {
                        Text(durationString ?? "")
                    }
                }
                .lineLimit(1)
                .padding(8)
                Rectangle().fill(Color.b_BorderLight)
                    .frame(height: 1)
                HStack(spacing: 0) {
                    Text(model.branchUIString)
                        .padding(8)
                        .foregroundColor(model.status.color)
                        .background(model.status.colorLight)
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
                    Text("# \(String(model.buildNumber))")
                        .padding(8)
                }
            }
            
        }
        .font(.footnote)
        .multilineTextAlignment(.leading)
        .foregroundColor(.b_TextBlack)
        
    }
}

struct BuildRowView_Previews: PreviewProvider {
    static var previews: some View {
        BuildRowView(model: .constant(BuildResponseItemModel.preview()))
            .preferredColorScheme(.light)
            .padding(8)
            
    }
}
