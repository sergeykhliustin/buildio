//
//  LogsView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 24.11.2021.
//

import SwiftUI
import Combine

private final class SearchModel: ObservableObject {
    @Published var searchText: String = ""
    private let logs: NSAttributedString?
    
    @Published var selectedRanges: [NSRange] = []
    @Published var selectedRangeIndex: Int?
    
    var selectedRange: Binding<NSRange?> {
        Binding(get: { [weak self] in
            guard let self = self else { return nil }
            if let selectedRangeIndex = self.selectedRangeIndex {
                return self.selectedRanges[selectedRangeIndex]
            } else {
                return nil
            }
        }, set: { _ in })
    }
    
    private var refresher: AnyCancellable?
    
    init(logs: NSAttributedString?) {
        self.logs = logs
        refresher =
        self.$searchText
            .dropFirst()
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.refresh()
                }
            }
    }
    
    private func refresh() {
        if let logs = logs, !searchText.isEmpty {
            do {
                let logsString = logs.string
                let regex = try NSRegularExpression(pattern: searchText, options: .caseInsensitive)
                let matches = regex.matches(in: logsString, options: [], range: NSRange(location: 0, length: logsString.count))
                selectedRanges = matches.map({ $0.range })
                if selectedRanges.count > 0 {
                    selectedRangeIndex = 0
                } else {
                    selectedRangeIndex = nil
                }
            } catch {
                logger.error(error)
            }
        } else {
            selectedRangeIndex = nil
            selectedRanges = []
        }
    }
    
    func next() {
        if let selectedRangeIndex = selectedRangeIndex, !selectedRanges.isEmpty {
            if selectedRangeIndex < selectedRanges.count - 1 {
                self.selectedRangeIndex = selectedRangeIndex + 1
            } else {
                self.selectedRangeIndex = 0
            }
        }
    }
}

struct LogsView: View {
    @StateObject private var searchModel: SearchModel
    @State private var follow: Bool = true
    @Environment(\.fullscreen) private var fullscreen
    
    private let logs: NSAttributedString?
    private let fetchRawAction: (() -> Void)?
    
    init(logs: NSAttributedString?, fetchRawAction: (() -> Void)? = nil) {
        self.logs = logs
        self._searchModel = StateObject(wrappedValue: SearchModel(logs: logs))
        self.fetchRawAction = fetchRawAction
    }
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                LogsTextView(follow: $follow, selectedRange: searchModel.selectedRange, attributed: logs)
                    .edgesIgnoringSafeArea(fullscreen.wrappedValue ? .all : [.bottom])
                
                let searchCount: Binding<String?> = Binding(get: {
                    if let index = searchModel.selectedRangeIndex {
                        return "\(index + 1)/\(searchModel.selectedRanges.count)"
                    } else {
                        return nil
                    }
                }, set: {_ in })
                
                LogsControls(fullscreen: fullscreen,
                             follow: $follow,
                             searchText: $searchModel.searchText,
                             searchCountText: searchCount,
                             onSubmit: { searchModel.next() },
                             onFetchRaw: fetchRawAction)
            }
        }
        .frame(maxHeight: .infinity)
        .navigationBarHidden(fullscreen.wrappedValue)
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
