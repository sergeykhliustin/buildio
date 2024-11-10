//
//  LogsView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 24.11.2021.
//

import SwiftUI
import Combine

struct LogsView: View {
    @State private var follow: Bool = true
    @State private var search: Bool = false
    @State var fullscreen: Bool = false

    private let logs: NSAttributedString?
    private let fetchFullLogAction: (() -> Void)?
    
    init(logs: NSAttributedString?, fetchFullLogAction: (() -> Void)? = nil) {
        self.logs = logs
        self.fetchFullLogAction = fetchFullLogAction
    }
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                LogsTextView(follow: $follow, search: $search, log: logs)
                    .edgesIgnoringSafeArea(fullscreen ? .all : [.bottom])
                
                LogsControls(fullscreen: $fullscreen,
                             follow: $follow,
                             search: $search,
                             onFetchFullLog: fetchFullLogAction)
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            fullscreen = false
        }
        .onDisappear {
            fullscreen = false
        }
    }
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView(logs: NSAttributedString(string: "Logs"))
    }
}
