//
//  PostDetailView.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 01/10/25.
//


import SwiftUI

import SwiftUI

struct PostDetailView: View {
    let post: PostCellModel
    let toggleFavorite: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(post.title.capitalizedFirst)
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(post.body.capitalizedFirst)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(.aeroBorderSecondary)
            .cornerRadius(12)
            .innerShadow(color: .blackPrimary, cornerRadius: 12)
            .padding()
        }
        .navigationTitle("Post Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toggleFavorite) {
                    Image(systemName: post.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(post.isFavorite ? .red : .gray)
                }
            }
        }
    }
}

