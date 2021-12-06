//
//  DebugScreenView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import SwiftUI
import SwiftyBeaver
import Rainbow

struct DebugScreenView: View {
    @State private var logs: NSAttributedString?
    
    var body: some View {
        VStack(spacing: 8) {
            LogsView(logs: $logs)
                .onAppear {
                    updateLogs()
                }
            ActionItem(title: "Reset UserDefaults", icon: "clear", action: {
                UserDefaults.standard.reset()
            })
        }
        .padding(.bottom, 8)
        .navigationTitle("Debug")
    }
    
    private func updateLogs() {
        guard let fileURL = SwiftyBeaver.destinations.compactMap({ $0 as? FileDestination }).first?.logFileURL else { return }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let string = String(data: data, encoding: .utf8) else { return }
        self.logs = Rainbow.chunkToAttributed(string)
    }
}

struct DebugLogsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DebugScreenView()
    }
}
