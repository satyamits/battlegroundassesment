//
//  SUIHeaderView.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 19/06/25.
//

import Foundation
import SwiftUI

struct SUIHeaderView<EditContent: View>: View {
    let title: String
    var isEnableEdit: Bool = false
    var backAction: (() -> Void)?
    var backTitle: String? = nil
    var editButtonAction: (() -> Void)?

    // store the content produced by the @ViewBuilder initializer
    private let editButtonContent: EditContent

    init(
        title: String,
        isEnableEdit: Bool = false,
        backAction: (() -> Void)? = nil,
        backTitle: String? = nil,
        editButtonAction: (() -> Void)? = nil,
        @ViewBuilder editButtonContent: () -> EditContent = { EmptyView() }
    ) {
        self.title = title
        self.isEnableEdit = isEnableEdit
        self.backAction = backAction
        self.backTitle = backTitle
        self.editButtonAction = editButtonAction
        self.editButtonContent = editButtonContent()
    }

    var body: some View {
        ZStack {
            HStack {
                if let backAction = backAction {
                    Button(action: backAction) {
                        HStack(spacing: 8) {
                           
                            if let backTitle = backTitle {
                                Text(backTitle)
                                    .font(.primary(.m16))
                                    .foregroundStyle(Color.themeWhite)
                            } else {
                                Image(systemName: backTitle == nil ? "chevron.left" : "chevron.left")
                                    .font(.primary(.s18))
                                    .foregroundStyle(Color.themeWhite)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                } 

                Spacer()
                if editButtonAction != nil {
                    Button(action: {
                        editButtonAction?()
                    }) {
                        editButtonContent
                            .foregroundColor(isEnableEdit ? Color.successGreen : Color.white.opacity(0.4))
                    }
                    .disabled(!isEnableEdit)
                    .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, 8)

            Text(title)
                .font(.primary(.s18))
                .foregroundColor(Color.blackPrimary)
//                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .background(Color.clear)
    }
}

