//
//  PagingViewModel.swift
//  Buildio
//
//  Created by severehed on 24.10.2021.
//

import Foundation

protocol PagingViewModel: BaseViewModel {
    var isLoadingPage: Bool { get set }
    var errorLoadingPage: Error? { get set }
    var lastPage: Bool { get set }
    
    func merge(value: VALUE?, newValue: VALUE?) -> VALUE?
    
    func fetchNext(_ completion: @escaping ((VALUE?, Error?) -> Void))
}

extension PagingViewModel {
    func loadNextPage() {
        guard !isLoadingPage && !lastPage else { return }
        isLoadingPage = true
        errorLoadingPage = nil
        fetchNext { [weak self] newValue, error in
            guard let self = self else { return }
            
            if let value = self.merge(value: self.value, newValue: newValue) {
                self.state = .value(value)
            }
            
            self.errorLoadingPage = error
            self.isLoadingPage = false
        }
    }
}
