//
//  AccountsScreenView.swift
//  Buildio
//
//  Created by severehed on 05.10.2021.
//

import SwiftUI

struct AccountsScreenView: View {
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    showingSheet.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                }
                .padding()
                .sheet(isPresented: $showingSheet) {
                    TokenScreenView(token: .constant(nil))
                }
            }
            List(0..<5) { _ in
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
        
    }
}

struct AccountsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsScreenView()
    }
}
