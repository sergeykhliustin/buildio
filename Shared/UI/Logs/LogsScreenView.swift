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
    private struct CustomTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .autocapitalization(.none)
                .padding(.horizontal, 4)
                .frame(height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 4).stroke(Color.b_Primary, lineWidth: 1).background(Color.b_BorderLight.opacity(0.8))
                )
                .cornerRadius(4)
                .font(.footnote)
        }
    }
    
    private struct CustomButtonStyle: ButtonStyle {
        @State private var hover: Bool = false
        @Binding var selected: Bool
        
        init(selected: Binding<Bool> = .constant(false)) {
            _selected = selected
        }
        
        func makeBody(configuration: ButtonStyle.Configuration) -> some View {
            let highlighted = selected || configuration.isPressed || hover
            configuration
                .label
                .frame(width: 30, height: 30, alignment: .center)
                .contentShape(Rectangle())
                .background(
                    RoundedRectangle(cornerRadius: 4).stroke(highlighted ? Color.b_Primary : .clear, lineWidth: 1).background(Color.b_BorderLight.opacity(highlighted ? 0.8 : 0.5))
                )
                .cornerRadius(4)
                .onHover { hover in
                    self.hover = hover
                }
        }
    }
    
    @Binding var fullscreen: Bool
    @Binding var follow: Bool
    @Binding var searchText: String
    @State private var search: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                HStack(spacing: 8) {
                    if search {
                        TextField("Search", text: $searchText)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    Button {
                        withAnimation {
                            search.toggle()
                            if !search {
                                searchText = ""
                            }
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .buttonStyle(CustomButtonStyle(selected: $search))
                    
                    Button {
                        withAnimation {
                            fullscreen.toggle()
                        }
                    } label: {
                        Image(systemName: fullscreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                    }
                }
                
                Spacer()
                
                if !follow {
                    Button {
                        follow.toggle()
                    } label: {
                        Image(systemName: "chevron.down.square")
                    }
                }
            }
        }
        .buttonStyle(CustomButtonStyle())
        .padding(8)
    }
}

struct LogsScreenView: BaseView {
    @StateObject var model: LogsViewModel
    @State private var follow: Bool = true
    @State private var searchText: String = ""
    @Environment(\.fullscreen) private var fullscreen
    
    init(build: BuildResponseItemModel) {
        self._model = StateObject(wrappedValue: LogsViewModel(build: build))
    }
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                LogsTextView(follow: $follow, attributed: logs, search: $searchText)
                    .edgesIgnoringSafeArea(fullscreen.wrappedValue ? .all : [])
                
                LogsControls(fullscreen: fullscreen, follow: $follow, searchText: $searchText)
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
        .onAppear {
            fullscreen.wrappedValue = false
        }
        .onDisappear {
            fullscreen.wrappedValue = false
        }
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
