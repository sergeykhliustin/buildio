//
//  ProfileViewModel.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import Foundation
import Models
import Combine

class ProfileViewModel: BaseViewModel<V0UserProfileDataModel> {
    override func fetch(params: Any?) -> AnyPublisher<V0UserProfileDataModel, ErrorResponse> {
        UserAPI().userProfile()
            .map({ $0.data })
            .eraseToAnyPublisher()
    }
}
