//
//  FontType.swift
//  Hyxpro-fitness-app
//
//  Created by Satyam Singh on 17/06/25.
//


import Foundation
import SwiftUI

protocol FontProtocol {
    func font(forLevel level: FontType.FontLevel) -> FontConvertible.Font
    var fontSizeIPhone: CGFloat { get }
}

enum FontType: FontProtocol {
    
    enum FontLevel {
        case primary
        case secondary
    }
    
    case r10, r12, r14, r16, r18, r20, r24, r28, r32, r40, r48, r64, r90
    case m10, m12, m14, m16, m18, m20, m24, m28, m32, m40, m48, m64, m90
    case s10, s12, s14, s16, s18, s20, s24, s28, s32, s40, s48, s64, s90
    case b10, b12, b14, b16, b18, b20, b24, b28, b32, b40, b48, b64, b90
    
    
    
    func font(forLevel level: FontLevel) -> FontConvertible.Font {
        switch level {
        case .primary:
            switch self {
            case .r10, .r12, .r14, .r16, .r18, .r20, .r24, .r28, .r32, .r40, .r48, .r64, .r90:
                return FontFamily.SFProRounded.regular.font(size: fontSizeIPhone)
            case .m10, .m12, .m14, .m16, .m18, .m20, .m24, .m28, .m32, .m40, .m48, .m64, .m90:
                return FontFamily.SFProRounded.medium.font(size: fontSizeIPhone)
            case .s10, .s12, .s14, .s16, .s18, .s20, .s24, .s28, .s32, .s40, .s48, .s64, .s90:
                return FontFamily.SFProRounded.semibold.font(size: fontSizeIPhone)
            case .b10, .b12, .b14, .b16, .b18, .b20, .b24, .b28, .b32, .b40, .b48, .b64, .b90:
                return FontFamily.SFProRounded.bold.font(size: fontSizeIPhone)
        }
        case .secondary:
            switch self {
            case .r10, .r12, .r14, .r16, .r18, .r20, .r24, .r28, .r32, .r40, .r48, .r64, .r90:
                return FontFamily.PlayfairDisplay.regular.font(size: fontSizeIPhone)
            case .m10, .m12, .m14, .m16, .m18, .m20, .m24, .m28, .m32, .m40, .m48, .m64, .m90:
                return FontFamily.PlayfairDisplay.medium.font(size: fontSizeIPhone)
            case .s10, .s12, .s14, .s16, .s18, .s20, .s24, .s28, .s32, .s40, .s48, .s64, .s90:
                return FontFamily.PlayfairDisplay.semiBold.font(size: fontSizeIPhone)
            case .b10, .b12, .b14, .b16, .b18, .b20, .b24, .b28, .b32, .b40, .b48, .b64, .b90:
                return FontFamily.PlayfairDisplay.bold.font(size: fontSizeIPhone)
        }
        }
    }
    
    var weight: FontConvertible.Font.Weight {
        switch self {
        case .r10, .r12, .r14, .r16, .r18, .r20, .r24, .r28, .r32, .r40, .r48, .b64, .r90:
            return .regular
        case .m10, .m12, .m14, .m16, .m18, .m20, .m24, .m28, .m32, .m40, .m48, .r64, .m90:
            return .medium
        case .s10, .s12, .s14, .s16, .s18, .s20, .s24, .s28, .s32, .s40, .s48, .m64, .s90:
            return .semibold
        case .b10, .b12, .b14, .b16, .b18, .b20, .b24, .b28, .b32, .b40, .b48, .s64, .b90:
            return .bold
        }
    }
    
    var fontSizeIPhone: CGFloat {
        switch self {
        case .r10, .m10, .s10, .b10:
            return 10
        case .r12, .m12, .s12, .b12:
            return 12
        case .r14, .m14, .s14, .b14:
            return 14
        case .r16, .m16, .s16, .b16:
            return 16
        case .r18, .m18, .s18, .b18:
            return 18
        case .r20, .m20, .s20, .b20:
            return 20
        case .r24, .m24, .s24, .b24:
            return 24
        case .r28, .m28, .s28, .b28:
            return 28
        case .r40, .m40, .s40, .b40:
            return 40
        case .r48, .m48, .s48, .b48:
            return 48
        case .r90, .m90, .s90, .b90:
            return 90
        case .r32, .m32, .s32, .b32:
            return 32
        case .r64, .m64, .s64, .b64:
            return 64
        }
    }
    
    var fontSizeIPad: CGFloat {
        return self.fontSizeIPhone + 0
    }
}
