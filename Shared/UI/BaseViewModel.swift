//
//  BaseViewModel.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import Foundation
import Combine

enum BaseViewModelState<T> {
    case loading
    case value(T)
    case error(Error?)
}

protocol BaseViewModel: ObservableObject {
    associatedtype VALUE
    
    var state: BaseViewModelState<VALUE> { get set }
    
    func fetch(_ completion: @escaping ((VALUE?, Error?) -> Void))
    
    func refresh()
    
    func beforeRefresh()
}

extension BaseViewModel {
    var value: VALUE? {
        if case .value(let value) = state {
            return value
        }
        return nil
    }
    
    func refresh() {
        beforeRefresh()
        state = .loading
        
        fetch { [weak self] value, error in
            guard let self = self else { return }
            if let value = value {
                self.state = .value(value)
            } else {
                self.state = .error(error)
            }
        }
    }
}
