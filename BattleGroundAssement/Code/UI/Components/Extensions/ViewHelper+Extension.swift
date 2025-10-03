//
//  ViewHelper+Extension.swift
//  BattleGroundAssement
//
//  Created by Satyam on 24/07/25.
//

import Foundation
import SwiftUI

import SwiftUI

extension View {
    func dottedRoundedBorder(
        borderColor: Color = .white.opacity(0.6),
        fillColor: Color? = nil,
        cornerRadius: CGFloat = 12,
        lineWidth: CGFloat = 1,
        dash: [CGFloat] = [5, 5]
    ) -> some View {
        self
            .background(
                Group {
                    if let fillColor {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(fillColor)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(borderColor,
                                  style: StrokeStyle(lineWidth: lineWidth, dash: dash))
            )
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension Binding where Value: Equatable {
    func isPresent<T: Equatable>(_ value: T) -> Binding<Bool> where Value == Optional<T> {
        Binding<Bool>(
            get: { self.wrappedValue == value },
            set: { isFocused in
                if isFocused {
                    self.wrappedValue = value
                } else if self.wrappedValue == value {
                    self.wrappedValue = nil
                }
            }
        )
    }
}

extension View {
    func innerShadowBottom(
        radius: CGFloat = 16,
        color: Color = .black.opacity(0.4),
        cornerRadius: CGFloat = 20
    ) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: 1)
                    .blur(radius: radius)
                    .mask(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .padding(.bottom, -radius * 2)
                            .padding(.top, radius)
                    )
            )
    }
}

extension String {
    var capitalizedFirst: String {
        prefix(1).uppercased() + dropFirst()
    }
    
    func firstAndLastName() -> (first: String?, last: String?) {
        let parts = self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }

        guard !parts.isEmpty else {
            return (nil, nil)
        }

        if parts.count == 1 {
            return (parts.first, nil) // only first name available
        }

        return (parts.first, parts.last)
    }
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    
    var digitsAndDotOnly: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: "")
            .filter { "0123456789.".contains($0) }
    }
    /// Examples:
    /// "9,875".compactNumber -> "9,875"
    /// "5678900".compactNumber -> "5.68M"
    var compactNumber: String {
        let cleaned = self.trimmingCharacters(in: .whitespacesAndNewlines)
                      .replacingOccurrences(of: ",", with: "")
        guard let value = Double(cleaned) else { return self }
        return compactNumberString(from: value)
    }
}

public extension Double {
    /// e.g. 9875.0 -> "9,875"
    /// 10000.0 -> "10.00k"
    var compactNumber: String {
        compactNumberString(from: self)
    }
}

public extension Int {
    /// e.g. 9875 -> "9,875"
    /// 10000 -> "10.00k"
    var compactNumber: String {
        compactNumberString(from: Double(self))
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool { self?.trimmed.isEmpty ?? true }
}

public func compactNumberString(from value: Double) -> String {
    let absValue = abs(value)
    let sign = value < 0 ? "-" : ""

    if absValue < 10_000 {
        // < 10k: show full number WITHOUT grouping commas.
        // If there's a fractional part, show up to 2 decimals.
        let hasFraction = absValue.truncatingRemainder(dividingBy: 1) != 0
        if hasFraction {
            let fmt = NumberFormatter()
            fmt.numberStyle = .decimal
            fmt.usesGroupingSeparator = false
            fmt.maximumFractionDigits = 2
            fmt.minimumFractionDigits = 0
            // keep locale default so decimal separator matches user locale; change if needed
            return "\(sign)\(fmt.string(from: NSNumber(value: absValue)) ?? String(absValue))"
        } else {
            return "\(sign)\(Int(absValue))"
        }
    } else if absValue < 1_000_000 {
        // thousands -> 'k' with 2 decimals
        let kValue = absValue / 1_000.0
        return "\(sign)\(String(format: "%.2f", kValue))k"
    } else {
        // millions -> 'M' with 2 decimals
        let mValue = absValue / 1_000_000.0
        return "\(sign)\(String(format: "%.2f", mValue))M"
    }
}

