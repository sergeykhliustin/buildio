//
//  BuildHeaderView.swift
//  
//
//  Created by Sergey Khliustin on 09.12.2021.
//

import SwiftUI
import Models

struct BuildHeaderView: View {
    @Environment(\.theme) private var theme
    let model: BuildResponseItemModel
    var body: some View {
        let extendedStatus = model.extendedStatus
        CollectionView(data: 0..<6, content: { index -> AnyView in
            switch index {
            case 0:
                return Text(extendedStatus.rawValue)
                    .foregroundColor(extendedStatus.color)
                    .padding(8)
                    .eraseToAnyView()
                    
            case 1:
                return HStack(spacing: 4) {
                    Image(.point_topleft_down_curvedto_point_bottomright_up)
                    Text(model.triggeredWorkflow)
                }
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 4).stroke(theme.borderColor))
                .eraseToAnyView()
            case 2:
                if let pullRequest = model.pullRequestId, pullRequest != 0 {
                    return HStack(spacing: 4) {
                        Image(.arrow_triangle_pull)
                        Text(String(pullRequest))
                    }
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color.fromString(model.branchOrigOwnerUIString)))
                    .eraseToAnyView()
                } else {
                    return EmptyView().eraseToAnyView()
                }
            case 3:
                return Group {
                    Text(model.branchOrigOwnerUIString)
                        .foregroundColor(.white)
                        .padding(8)
                        .lineLimit(2)
                }
                    .background(Color.fromString(model.branchOrigOwnerUIString))
                    .cornerRadius(4)
                    .eraseToAnyView()
                
            case 4:
                if model.pullRequestTargetBranch != nil {
                    return Image(.arrow_right).padding(8).eraseToAnyView()
                } else {
                    return EmptyView().eraseToAnyView()
                }
            case 5:
                if let targetBranch = model.pullRequestTargetBranch {
                    return Group {
                        Text(targetBranch)
                            .foregroundColor(.white)
                            .padding(8)
                            .lineLimit(1)
                    }
                        .background(Color.fromString(targetBranch))
                        .cornerRadius(4)
                        .eraseToAnyView()
                } else {
                    return EmptyView().eraseToAnyView()
                }
            default:
                return EmptyView().eraseToAnyView()
            }
        })
            .padding(.top, 4)
    }
}

struct BuildHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        BuildHeaderView(model: BuildResponseItemModel.preview())
    }
}
