//
//  AppFont.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 17/06/25.
//

import Foundation
import SwiftUI

struct AppFont {
    
    static func primary(_ fontType: FontType) -> UIFont {
        return fontType.font(forLevel: .primary)
    }
    
    static func secondary(_ fontType: FontType) -> UIFont {
        return fontType.font(forLevel: .secondary)
    }
    
}

extension SwiftUI.Font {
    static func primary(_ fontType: FontType) -> SwiftUI.Font {
        return SwiftUI.Font(fontType.font(forLevel: .primary))
    }
    
    static func secondary(_ fontType: FontType) -> SwiftUI.Font {
        return SwiftUI.Font(fontType.font(forLevel: .secondary))
    }
}
