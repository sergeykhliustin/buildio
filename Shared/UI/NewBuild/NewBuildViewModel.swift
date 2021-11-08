//
//  NewBuildViewModel.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 08.11.2021.
//

import Foundation
import Models
import Combine

final class NewBuildViewModel: BaseViewModel<[String]> {
    @Published var app: V0AppResponseItemModel?
    
    override func fetch(params: Any?) -> AnyPublisher<[String], ErrorResponse> {
        ApplicationAPI()
            .branchList(appSlug: app?.slug ?? "")
            .map( { $0.data ?? [] } )
            .eraseToAnyPublisher()
    }
}
