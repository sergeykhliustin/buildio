//
//  LogsScreenView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import SwiftUI
import Models
import Rainbow

private struct LogsControls: View {
    @Binding var fullscreen: Bool
    @Binding var follow: Bool
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Button {
                    withAnimation {
                        fullscreen.toggle()
                    }
                } label: {
                    Image(systemName: fullscreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                        .padding(8)
                }
                .background(RoundedRectangle(cornerRadius: 4).fill(Color.b_BorderLight).opacity(0.5))
                .contentShape(Rectangle())
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 16))
                
                Spacer()
                
                if !follow {
                    Button {
                        follow.toggle()
                    } label: {
                        Text("Follow")
                            .font(.footnote)
                            .padding(8)
                    }
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.b_BorderLight.opacity(0.5)))
                    .contentShape(Rectangle())
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 16))
                }
            }
        }
    }
}

struct LogsScreenView: BaseView {
    @StateObject var model: LogsViewModel
    @State private var follow: Bool = true
    @Environment(\.fullscreen) private var fullscreen
    
    init(build: BuildResponseItemModel) {
        self._model = StateObject(wrappedValue: LogsViewModel(build: build))
    }
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                LogsTextView(follow: $follow, attributed: logs)
                    .edgesIgnoringSafeArea(fullscreen.wrappedValue ? .all : [])
                
                LogsControls(fullscreen: fullscreen, follow: $follow)
            }
        }
        .frame(maxHeight: .infinity)
        .navigationTitle("Build #\(String(model.build.buildNumber)) logs")
        .toolbar {
            if case .loading = model.state {
                ProgressView()
            }
        }
        .navigationBarHidden(fullscreen.wrappedValue)
        .statusBar(hidden: fullscreen.wrappedValue)
    }
    
    private var logs: NSAttributedString {
        return model.attributedLogs ?? NSAttributedString(string: "Loading logs...", attributes: [.foregroundColor: UIColor.white])
    }
}

struct LogsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LogsScreenView(build: BuildResponseItemModel.preview())
    }
}
