//
//  CustomTextField.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 18/06/25.
//

import Foundation
import SwiftUI

struct CustomTextField<T: Equatable>: View {
    @Binding var value: T
    var placeholder: String = ""
    var background: AnyShapeStyle
    var alignment: TextAlignment = .leading
    @State private var text: String = ""
    var foregroundColor: Color = Color.themeWhite
    var padding: CGFloat = 4

    // New: allow parent to control focus
    @FocusState private var fieldFocused: Bool
    var isFocusedBinding: Binding<Bool>? = nil

    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .foregroundColor(foregroundColor)
            .font(.primary(.m18).smallCaps())
            .padding(padding)
            .background(self.background)
            .cornerRadius(8)
            .multilineTextAlignment(alignment)
            .focused($fieldFocused)
            .onAppear {
                self.text = formattedValue(value)
                // Sync initial focus state
                if let isFocusedBinding {
                    fieldFocused = isFocusedBinding.wrappedValue
                }
            }
            .onChange(of: text) { _, newValue in
                updateValue(from: newValue)
            }
            .onChange(of: value) { _, newValue in
                let newFormatted = formattedValue(newValue)
                if newFormatted != self.text {
                    self.text = newFormatted
                }
            }
            .onChange(of: fieldFocused) { _, newVal in
                // Propagate focus changes upward if provided
                isFocusedBinding?.wrappedValue = newVal
            }
            .onChange(of: isFocusedBinding?.wrappedValue ?? false) { _, newVal in
                // Parent focus toggles should update this field
                if fieldFocused != newVal {
                    fieldFocused = newVal
                }
            }
    }

    private var keyboardType: UIKeyboardType {
        switch T.self {
        case is Int.Type: return .numberPad
        case is Double.Type, is Float.Type: return .decimalPad
        default: return .default
        }
    }

    private func formattedValue(_ val: T) -> String {
        switch val {
        case let intValue as Int:
            return "\(intValue)"
        case let doubleValue as Double:
            return doubleValue.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(doubleValue))"
                : String(format: "%.2f", doubleValue)
        case let floatValue as Float:
            return floatValue.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(floatValue))"
                : String(format: "%.2f", floatValue)
        case let stringValue as String:
            return stringValue
        default:
            return ""
        }
    }

    private func updateValue(from newValue: String) {
        switch T.self {
        case is Int.Type:
            if let intVal = Int(newValue) {
                self.value = intVal as! T
            }
        case is Double.Type:
            if let doubleVal = Double(newValue) {
                self.value = doubleVal as! T
            }
        case is Float.Type:
            if let floatVal = Float(newValue) {
                self.value = floatVal as! T
            }
        case is String.Type:
            self.value = newValue as! T
        default:
            break
        }
    }
}
