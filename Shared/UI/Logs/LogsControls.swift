//
//  LogsControls.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 24.11.2021.
//

import SwiftUI
import Introspect

struct LogsControls: View {
    private struct LogsSearchTextFieldStyle: TextFieldStyle {
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
    @Binding var searchCountText: String?
    
    var onSubmit: (() -> Void)?
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                HStack(spacing: 8) {
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
                            RoundedRectangle(cornerRadius: 4).stroke(Color.b_Primary, lineWidth: 1).background(Color.b_BorderLight.opacity(0.8))
                        )
                        .cornerRadius(4)
                }
                HStack(spacing: 8) {
                    if search {
                        TextField("Search", text: $searchText)
                            .introspectTextField { textField in
                                textField.returnKeyType = .next
                            }
                            .textFieldStyle(LogsSearchTextFieldStyle())
                            
//                        if #available(iOS 15.0, *) {
//
//                                .submitLabel(.next)
//                                .onSubmit {
//                                    onSubmit?()
//                                }
//                        } else {
//                            TextField("Search", text: $searchText)
//                                .textFieldStyle(CustomTextFieldStyle())
//                        }
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
