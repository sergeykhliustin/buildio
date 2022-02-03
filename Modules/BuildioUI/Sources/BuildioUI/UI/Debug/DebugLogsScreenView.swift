//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 20.01.2022.
//

import SwiftUI
import Rainbow
import SwiftyBeaver
import BuildioLogic

struct DebugLogsScreenView: BaseView {
    @StateObject var model = DebugLogsViewModel()
    @State private var logs: NSAttributedString?
    
    var body: some View {
        LogsView(logs: model.value)
            .navigationTitle("Logs")
    }
}

struct DebugLogsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DebugLogsScreenView()
    }
}
