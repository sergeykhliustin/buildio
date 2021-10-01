//
//  ProfileView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

struct ProfileView: View, RefreshableView {
    typealias VALUE = V0UserProfileDataModel
    
    @ObservedObject var model: BaseViewModel<V0UserProfileDataModel> = ProfileViewModel()
    
    var body: some View {
        buildBody()
    }
    
    func buildValueView(_ value: V0UserProfileDataModel) -> AnyView {
        AnyView(
            VStack {
                HStack {
                    Spacer()
                    Button("Refresh", action: model.refresh)
                }
                
                Spacer()
                Text(value.email ?? "")
                Spacer()
            }
        )
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
