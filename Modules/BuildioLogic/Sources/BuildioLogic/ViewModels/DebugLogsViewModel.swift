//
//  DebugLogsViewModel.swift
//  
//
//  Created by Sergey Khliustin on 03.02.2022.
//

import Foundation
import SwiftyBeaver
import Rainbow

public class DebugLogsViewModel: BaseViewModel<NSAttributedString> {
    override class var shouldRefreshOnInit: Bool {
        return true
    }
    
    public override init() {
        super.init()
    }
    
    override func fetch() async throws -> NSAttributedString {
        guard let fileURL = SwiftyBeaver.destinations.compactMap({ $0 as? FileDestination }).first?.logFileURL else { throw ErrorResponse.empty }
        guard let data = try? Data(contentsOf: fileURL) else { throw ErrorResponse.empty }
        guard let string = String(data: data, encoding: .utf8) else { throw ErrorResponse.empty }
        return Rainbow.chunkToAttributed(string)
    }
}
