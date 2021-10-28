//
//  ProfileViewModel.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import Foundation
import Models
import Combine

class ProfileViewModel: BaseViewModel {
    var tokenRefresher: AnyCancellable?
    
    @Published var state: BaseViewModelState<V0UserProfileDataModel> = .idle
    
    init() {
        refresh()
    }
    
    func beforeRefresh() {
        
    }
    
    func fetch() -> AnyPublisher<V0UserProfileDataModel, Error> {
        UserAPI.userProfile()
            .map({ $0.data })
            .eraseToAnyPublisher()
    }
}
