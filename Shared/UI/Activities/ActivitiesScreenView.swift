//
//  ActivitiesScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 03.11.2021.
//

import SwiftUI
import Models

struct ActivitiesScreenView: PagingView {
    @StateObject var model: ActivitiesViewModel = ActivitiesViewModel()
    @State var selected: V0ActivityEventResponseItemModel?
    
    func buildItemView(_ item: V0ActivityEventResponseItemModel) -> some View {
        ListItemWrapper(action: {
            
        }, content: {
            ActivityRowView(model: item)
        })
    }
    
    func additionalToolbarItems() -> some View {
        
    }
}

struct ActivitiesScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesScreenView()
    }
}
