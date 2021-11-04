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
        ActivityRowView(model: item)
            .onAppear {
                if item == model.items.last {
                    logger.debug("UI load more activities")
                    model.nextPage()
                }
            }
    }
    
    func additionalToolbarItems() -> some View {
        
    }
}

struct ActivitiesScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesScreenView()
    }
}
