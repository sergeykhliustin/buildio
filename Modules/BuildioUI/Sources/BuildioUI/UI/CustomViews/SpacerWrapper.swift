//
//  SpacerWrapper.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import SwiftUI

struct SpacerWrapper<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                content()
                Spacer(minLength: 0)
            }
            Spacer(minLength: 0)
        }
    }
}

struct SpacerWrapper_Previews: PreviewProvider {
    static var previews: some View {
        SpacerWrapper {
            Text("some")
        }
    }
}
