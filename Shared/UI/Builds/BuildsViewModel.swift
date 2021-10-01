//
//  BuildsViewModel.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import Foundation

class BuildsViewModel: BaseViewModel<[V0BuildListAllResponseItemModel]> {
    override func fetch(_ completion: @escaping (([V0BuildListAllResponseItemModel]?, Error?) -> Void)) {
        BuildsAPI.buildListAll(limit: 10) { data, error in
            completion(data?.data, error)
        }
    }
}
