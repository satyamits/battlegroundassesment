//
//  SearchBar.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 19/06/25.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    
    let placeholder: String
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 8)
                Text(placeholder)
                    .font(.primary(.r18))
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 32)
            }
            HStack {
                TextField(placeholder, text: $text)
                    .padding(10)
                    .font(.primary(.r18))
                    .foregroundStyle(Color.blackPrimary)
                    .background(Color.themeWhite)
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            Spacer()
                            if !text.isEmpty {
                                Button(action: { text = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 8)
                            }
                        }
                    )
            }
        }
        
    }
}
