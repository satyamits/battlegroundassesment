//
//  FavoritesView.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 02/10/25.
//


import SwiftUI

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: HomeListViewModel
    
    var body: some View {
        VStack {
            // Search bar for filtering favorites
            SUIHeaderView(title: "Favorites ❤️")
            SearchBar(placeholder: "Enter Search Text", text: self.$viewModel.favSearchText)
            
            if viewModel.favoritePosts.isEmpty {
                Spacer()
                Text("No favorites yet ❤️")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.groupedFavoritePosts.keys.sorted(), id: \.self) { key in
                            Section(header: Text(key)) {
                                ForEach(viewModel.groupedFavoritePosts[key] ?? [], id: \.id) { post in
                                    NavigationLink {
                                        PostDetailView(post: post) {
                                            viewModel.toggleFavorite(for: post)
                                        }
                                    } label: {
                                        itemCard(post) {
                                            viewModel.toggleFavorite(for: post)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(.aeroBorderSecondary)
    }
    
    // Same itemCard as HomeListView
    func itemCard(_ post: PostCellModel, like: @escaping () -> Void) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(post.title).font(.headline)
                Text("User ID: \(post.userID)").font(.subheadline)
            }
            Spacer()
            VStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(post.isFavorite ? .red : .gray)
                    .onTapGesture {
                        like()
                    }
                Spacer()
            }
            Image(systemName: "chevron.right")
                .foregroundStyle(.darkGrey)
        }
        .padding()
        .innerShadow(color: .PRIMARY, radius: 8, cornerRadius: 12)
    }
}
