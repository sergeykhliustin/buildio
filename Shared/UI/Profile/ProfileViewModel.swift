//
//  ProfileViewModel.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import Foundation
import Models

class ProfileViewModel: BaseViewModel<V0UserProfileDataModel> {
    override func fetch(_ completion: @escaping ((V0UserProfileDataModel?, Error?) -> Void)) {
        
        UserAPI.userProfile { data, error in
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                DispatchQueue.main.async {
                    completion(data?.data, error)
                }
            }
        }
    }
}
