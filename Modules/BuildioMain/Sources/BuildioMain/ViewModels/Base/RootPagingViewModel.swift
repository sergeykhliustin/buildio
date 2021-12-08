//
//  RootPagingViewModel.swift
//  
//
//  Created by Sergey Khliustin on 08.12.2021.
//

import Models

class RootPagingViewModel<VALUE: PagingResponseModel>: PagingViewModel<VALUE> {
    
    override class var shouldRefreshOnInit: Bool {
        return true
    }
    
    override class var shouldHandleTokenUpdates: Bool {
        return true
    }
    
    override class var shouldHandleActivityUpdates: Bool {
        return true
    }
    
    override var shouldRefreshAfterBackground: Bool {
        return true
    }
}
