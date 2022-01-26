//
//  AbortButton.swift
//  
//
//  Created by Sergey Khliustin on 26.01.2022.
//

import SwiftUI

struct AbortButton: View {
    private let action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("Abort")
            }
        }
        .buttonStyle(AbortButtonStyle())
    }
}

#if DEBUG
struct AbortButton_Preview: PreviewProvider {
    static var previews: some View {
        AbortButton({})
    }
}
#endif
