//
//  SnackbarView.swift
//  SpotlightIndexDemo
//
//

import SwiftUI

struct SnackbarView: View {
    
    let snackbar: Snackbar
    let onActionTapped: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if let image = snackbar.icon.image {
                image
                    .resizable()
                    .foregroundColor(snackbar.icon.themeColor)
                    .frame(width: 30, height: 30)
            }
            VStack(alignment: .leading) {
                if let title = snackbar.title, !title.isEmpty {
                    Text(title)
                        .font(.primary(.s18))
                        .foregroundColor(snackbar.decorator.titleTextColor)
                }
                Text(snackbar.message)
                    .font(.primary(.r14))
                    .foregroundColor(snackbar.decorator.messageTextColor)
            }
            Spacer(minLength: 10)
            
            actionButton
        }
        .padding()
        .frame(minWidth: 0, maxWidth: snackbar.decorator.width)
        .background(snackbar.decorator.backgroundColor)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .shadow(color: Color.black.opacity(0.8), radius: 8)
    }
    
    @ViewBuilder var actionButton: some View {
        switch snackbar.action {
        case .none:
            EmptyView()
        case .xMark(let color):
            Button {
                onActionTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(color)
                    .frame(width: 25, height: 25)
            }
        case .text(let string, let color, _):
            Button {
                onActionTapped()
            } label: {
                Text(string)
                    .font(.primary(.s14))
                    .underline()
                    .foregroundStyle(color)
            }
        case .systemImage(let imageName, let color, _):
            Button {
                onActionTapped()
            } label: {
                Image(systemName: imageName)
                    .foregroundColor(color)
                    .frame(width: 25, height: 25)
            }
        case .imageName(let imageName, _):
            Button {
                onActionTapped()
            } label: {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
            }
        }
    }
    
}

#Preview {
    SnackbarView(
        snackbar: Snackbar(
            title: "title",
            message: "message",
            properties: .default,
            icon: .info
        ),
        onActionTapped: {
        })
}
