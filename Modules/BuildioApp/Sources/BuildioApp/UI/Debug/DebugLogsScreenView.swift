//
//  DebugLogsScreenView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//
#if DEBUG
import SwiftUI
import SwiftyBeaver
import Rainbow

struct DebugLogsScreenView: View {
    @State private var logs: NSAttributedString?
    
    var body: some View {
        LogsView(logs: $logs)
            .onAppear {
                updateLogs()
            }
            .navigationTitle("Debug logs")
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
        DebugLogsScreenView()
    }
}
#endif