//
//  Font+Additions.swift
//  
//
//  Created by Sergey Khliustin on 06.12.2022.
//

import Foundation
import UIKit
import SwiftUI

extension Font {
    var uiFont: UIFont {
        return UIFont.preferredFont(from: self)
    }
}

extension UIFont {
    class func preferredFont(from font: Font) -> UIFont {
        let style: UIFont.TextStyle
        switch font {
        case .largeTitle:  style = .largeTitle
        case .title:       style = .title1
        case .title2:      style = .title2
        case .title3:      style = .title3
        case .headline:    style = .headline
        case .subheadline: style = .subheadline
        case .callout:     style = .callout
        case .caption:     style = .caption1
        case .caption2:    style = .caption2
        case .footnote:    style = .footnote
        case .body: fallthrough
        default:           style = .body
        }
        return  UIFont.preferredFont(forTextStyle: style)
    }
}
