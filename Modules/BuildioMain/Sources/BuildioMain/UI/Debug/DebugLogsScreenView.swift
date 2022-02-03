//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 20.01.2022.
//

import SwiftUI
import Rainbow
import SwiftyBeaver

struct DebugLogsScreenView: View {
    @State private var logs: NSAttributedString?
    
    var body: some View {
        LogsView(logs: logs)
            .onAppear(perform: {
                updateLogs()
            })
            .navigationTitle("Logs")
    }
    
    private func updateLogs() {
        DispatchQueue.global().async {
            guard let fileURL = SwiftyBeaver.destinations.compactMap({ $0 as? FileDestination }).first?.logFileURL else { return }
            guard let data = try? Data(contentsOf: fileURL) else { return }
            guard let string = String(data: data, encoding: .utf8) else { return }
            self.logs = Rainbow.chunkToAttributed(string)
        }
    }
}

struct DebugLogsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DebugLogsScreenView()
    }
}
