//
//  LogsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import SwiftUI
import Models
import BuildioLogic

struct LogsScreenView: BaseView {
    @EnvironmentObject var model: LogsViewModel
    @Environment(\.fullscreen) private var fullscreen
    private let build: BuildResponseItemModel
    
    init(build: BuildResponseItemModel) {
        self.build = build
    }
    
    var body: some View {
        let fetchFullLogAction: (() -> Void)? = model.canFetchFullLog ? { model.fetchFullLog() } : nil
        LogsView(logs: model.attributedLogs, fetchFullLogAction: fetchFullLogAction)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if case .loading = model.state {
                        ProgressView()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let value = model.rawLogs {
                        Button {
                            let url = URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent("build_\(model.build.slug).log"))
                            do {
                                try value.write(to: url, atomically: true, encoding: .utf8)
                                let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                controller.popoverPresentationController?.sourceView = UIView()
                                UIApplication.shared.windows.first?.rootViewController?.present(controller, animated: true)
                            } catch {
                                logger.error(error)
                            }
                        } label: {
                            Image(.square_and_arrow_up)
                        }
                    }
                }

            }
    }
}

struct LogsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LogsScreenView(build: BuildResponseItemModel.preview())
    }
}
