//
//  LogsControls.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 24.11.2021.
//

import SwiftUI

struct LogsControls: View {
    private struct LogsSearchTextFieldStyle: TextFieldStyle {
        @Environment(\.theme) private var theme
        
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .autocapitalization(.none)
                .padding(.horizontal, 4)
                .frame(height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 4).stroke(theme.accentColor, lineWidth: 1).background(theme.logControlColor.opacity(0.8))
                )
                .cornerRadius(4)
                .font(.footnote)
        }
    }
    
    private struct CustomButtonStyle: ButtonStyle {
        @Environment(\.theme) private var theme
        
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
                    RoundedRectangle(cornerRadius: 4).stroke(highlighted ? theme.accentColor : .clear, lineWidth: 1).background(theme.logControlColor.opacity(highlighted ? 0.8 : 0.5))
                )
                .cornerRadius(4)
                .onHover { hover in
                    self.hover = hover
                }
        }
    }
    
    private struct FetchRawButtonStyle: ButtonStyle {
        @Environment(\.theme) private var theme
        
        @State private var hover: Bool = false
        @Binding var selected: Bool
        
        init(selected: Binding<Bool> = .constant(false)) {
            _selected = selected
        }
        
        func makeBody(configuration: ButtonStyle.Configuration) -> some View {
            let highlighted = selected || configuration.isPressed || hover
            configuration
                .label
                .padding(.horizontal, 4)
                .frame(height: 30, alignment: .center)
                .contentShape(Rectangle())
                .background(
                    RoundedRectangle(cornerRadius: 4).stroke(highlighted ? theme.accentColor : .clear, lineWidth: 1).background(theme.logControlColor.opacity(highlighted ? 0.8 : 0.5))
                )
                .cornerRadius(4)
                .onHover { hover in
                    self.hover = hover
                }
        }
    }
    
    @Environment(\.theme) private var theme
    @Binding var fullscreen: Bool
    @Binding var follow: Bool
    @Binding var searchText: String
    @State private var search: Bool = false
    @Binding var searchCountText: String?
    
    var onSubmit: (() -> Void)?
    var onFetchRaw: (() -> Void)?
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                HStack(spacing: 8) {
                    if let onFetchRaw = onFetchRaw {
                        Button(action: onFetchRaw) {
                            Text("Fetch full log")
                        }
                        .buttonStyle(FetchRawButtonStyle())
                    }
                    Button {
                        withAnimation {
                            fullscreen.toggle()
                        }
                    } label: {
                        Image(systemName: fullscreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                    }
                }
                
                Spacer()
                if let searchCountText = searchCountText, search {
                    Text(searchCountText)
                        .font(.footnote)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 4).stroke(theme.accentColor, lineWidth: 1).background(theme.logControlColor.opacity(0.8))
                        )
                        .cornerRadius(4)
                }
                HStack(spacing: 8) {
                    if search {
                        TextField("Search", text: $searchText)
                            .textFieldStyle(LogsSearchTextFieldStyle())
                        Button {
                            onSubmit?()
                        } label: {
                            Image(systemName: "chevron.compact.down")
                        }
                        .buttonStyle(CustomButtonStyle(selected: .constant(true)))
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
                    
                    if !follow && !search {
                        Button {
                            follow.toggle()
                        } label: {
                            Image(systemName: "chevron.down.square")
                        }
                    }
                }
            }
        }
        .buttonStyle(CustomButtonStyle())
        .padding(8)
    }
}
