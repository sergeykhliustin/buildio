//
//  BaseViewModel.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import Foundation
import Combine

class BaseViewModel<T>: ObservableObject {
    @Published var value: T?
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    init() {
        refresh()
    }
    
    func refresh() {
        isLoading = true
        value = nil
        error = nil
        
        fetch { [weak self] value, error in
            guard let self = self else { return }
            
            self.value = value
            self.error = error
            self.isLoading = false
        }
    }
    
    func fetch(_ completion: @escaping ((T?, Error?) -> Void)) {
        fatalError("Should override")
    }
}
