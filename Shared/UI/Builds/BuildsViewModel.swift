//
//  BuildsViewModel.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import Foundation
import Models
import Combine

class BuildsViewModel: PagingViewModel {
    var tokenRefresher: AnyCancellable?
    
    @Published var isLoadingPage: Bool = false
    @Published var errorLoadingPage: Error? = nil
    @Published var state: BaseViewModelState<Array<V0BuildListAllResponseItemModel>> = .loading
    @Published var lastPage: Bool = false
    
    private let fetchLimit: Int = 10
    
    init() {
        refresh()
    }
    
    func beforeRefresh() {
        lastPage = false
    }
    
    func fetch(_ completion: @escaping (([V0BuildListAllResponseItemModel]?, Error?) -> Void)) {
        BuildsAPI.buildListAll(limit: fetchLimit) { data, error in
            completion(data?.data, error)
        }
    }
    
    func fetchNext(_ completion: @escaping (([V0BuildListAllResponseItemModel]?, Error?) -> Void)) {
        BuildsAPI.buildListAll(next: self.value?.last?.slug, limit: fetchLimit) { data, error in
            completion(data?.data, error)
        }
    }
    
    func merge(value: [V0BuildListAllResponseItemModel]?, newValue: [V0BuildListAllResponseItemModel]?) -> [V0BuildListAllResponseItemModel]? {
        guard let value = value else {
            return newValue
        }
        guard let newValue = newValue else {
            return value
        }
        
        return value + newValue.dropFirst()
    }
}
