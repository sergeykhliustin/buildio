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
    @Environment(\.fullscreen) private var fullscreen
    
    private let logs: NSAttributedString?
    private let fetchRawAction: (() -> Void)?
    
    init(logs: NSAttributedString?, fetchRawAction: (() -> Void)? = nil) {
        self.logs = logs
        self.fetchRawAction = fetchRawAction
    }
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                LogsTextView(follow: $follow, search: $search, log: logs)
                    .edgesIgnoringSafeArea(fullscreen.wrappedValue ? .all : [.bottom])
                
                LogsControls(fullscreen: fullscreen,
                             follow: $follow,
                             search: $search,
                             onFetchRaw: fetchRawAction)
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            fullscreen.wrappedValue = false
        }
        .onDisappear {
            fullscreen.wrappedValue = false
        }
    }
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView(logs: NSAttributedString(string: "Logs"))
    }
}
