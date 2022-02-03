//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 25.01.2022.
//

import Foundation
import Combine

public class BaseApiViewModel<ValueType>: BaseViewModel<ValueType> {
    private let tokenManager: TokenManager
    let apiFactory: ApiFactory
    
    private var tokenRefresher: AnyCancellable?
    private var tokenUpdated: Bool = false
    
    class var shouldHandleTokenUpdates: Bool {
        return false
    }
    
    init(_ tokenManager: TokenManager) {
        self.tokenManager = tokenManager
        self.apiFactory = ApiFactory(token: tokenManager.token?.token)
        
        super.init()
        
        if Self.shouldHandleTokenUpdates {
            tokenRefresher = tokenManager.$token
                .dropFirst()
                .sink { [weak self] value in
                    DispatchQueue.main.async {
                        self?.tokenUpdated = true
                        self?.refresh()
                    }
                }
        }
    }
    
    func beforeRefresh(_ tokenUpdated: Bool) {
        if tokenUpdated {
            self.value = nil
        }
    }
    
    public override func refresh() {
        beforeRefresh(tokenUpdated)
        tokenUpdated = false
        super.refresh()
    }
}
