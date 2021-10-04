//
//  MainCoordinator.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import Foundation
import SwiftUI
import Combine
import Models

class MainCoordinator: ObservableObject {
    @Published var token: String?
    @Published var user: Result<V0UserProfileRespModel, Error>?
    private var tokenSaver: AnyCancellable?
    init() {
        token = UserDefaults.standard.token
        tokenSaver = $token.sink { [weak self] token in
            guard let self = self else { return }
            UserDefaults.standard.token = token
            if let token = token {
                SwaggerClientAPI.customHeaders = ["Authorization": token]
                self.fetchMe()
            }
        }
    }
    
    func fetchMe() {
        user = nil
        UserAPI.userProfile { [weak self] data, error in
            guard let self = self else { return }
            if let data = data {
                self.user = .success(data)
            } else {
                self.user = .failure(error!)
                self.token = nil
            }
        }
    }
}
