import Foundation
import SwiftUI

enum Images: String {
    case checkmark
    case gearshape
    case trash
    case plus
    case key
    case xmark
    case point_topleft_down_curvedto_point_bottomright_up
    case arrow_triangle_pull
    case arrow_right
    case square_and_arrow_up
    case clock
    case coloncurrencysign_circle
    case number
    case square_stack_3d_up
    case bolt_fill
    case tag
    case note_text
    case nosign
    case archivebox
    case hammer
    case bell
    case delete_left
    case doc_on_clipboard
    case arrow_down_right_and_arrow_up_left
    case arrow_up_left_and_arrow_down_right
    case chevron_compact_down
    case magnifyingglass
    case chevron_down_square
    case chevron_right
    case hourglass
    case square_and_arrow_up_fill
    case empty // Will produce empty Image
    case doc_plaintext
    case clear
    case eyedropper_halffull
    case gearshape_2
    case hammer_fill
    case tray_2
    case tray_2_fill
    case key_fill
    case bell_fill
    case gearshape_fill
    case bell_slash
    case text_justify
}

extension Image {
    init(_ system: Images) {
        self.init(systemName: system.rawValue.replacingOccurrences(of: "_", with: "."))
    }
}
