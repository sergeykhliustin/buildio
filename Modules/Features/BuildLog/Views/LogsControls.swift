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
                    RoundedRectangle(cornerRadius: 4).stroke(theme.accentColor.color, lineWidth: 1).background(theme.logControlColor.color.opacity(0.8))
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
                .frame(width: 40, height: 40, alignment: .center)
                .contentShape(Rectangle())
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(highlighted ? theme.accentColor.color : .clear, lineWidth: 1)
                        .background(highlighted ? theme.logControlHighlightedColor.color : theme.logControlColor.color)
                        .opacity(highlighted ? 1.0 : 0.7)
                )
                .cornerRadius(4)
                .onHover { hover in
                    self.hover = hover
                }
        }
    }
    
    private struct FetchFullLogButtonStyle: ButtonStyle {
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
                .frame(height: 40, alignment: .center)
                .contentShape(Rectangle())
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(highlighted ? theme.accentColor.color : .clear, lineWidth: 1)
                        .background(highlighted ? theme.logControlHighlightedColor.color : theme.logControlColor.color)

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
    @Binding var search: Bool
    var onFetchFullLog: (() -> Void)?
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Spacer()
                HStack(spacing: 8) {
                    if let onFetchFullLog = onFetchFullLog {
                        Button(action: onFetchFullLog) {
                            Text("Fetch full log")
                        }
                        .buttonStyle(FetchFullLogButtonStyle())
                    }
                    Button {
                        withAnimation {
                            fullscreen.toggle()
                        }
                    } label: {
                        if fullscreen {
                            Image(.arrow_down_right_and_arrow_up_left)
                                .renderingMode(.template)
                                .foregroundColor(.white)
                        } else {
                            Image(fullscreen ? .arrow_down_right_and_arrow_up_left : .arrow_up_left_and_arrow_down_right)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: $fullscreen))
                    Spacer()
                    if #available(iOS 16.0, *) {
                        Button {
                            withAnimation {
                                search.toggle()
                            }
                        } label: {
                            if search {
                                Image(.magnifyingglass)
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                            } else {
                                Image(.magnifyingglass)
                            }
                        }
                        .buttonStyle(CustomButtonStyle(selected: $search))
                    }

                    Button {
                        follow.toggle()
                    } label: {
                        if follow {
                            Image(.chevron_down_square)
                                .renderingMode(.template)
                                .foregroundColor(.white)
                        } else {
                            Image(.chevron_down_square)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: $follow))
                }
            }
        }
        .buttonStyle(CustomButtonStyle())
        .padding(8)
    }
}
