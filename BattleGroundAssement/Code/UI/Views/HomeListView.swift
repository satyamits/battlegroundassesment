//
//  HomeListView.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 01/10/25.
//

import Foundation
import SwiftUI

struct HomeListView: View {
    
    @StateObject var viewModel: HomeListViewModel
    
    var body: some View {
        VStack {
            SUIHeaderView(title: "Recent Post")
            SearchBar(placeholder: "Enter Search Text", text: self.$viewModel.searchText)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.groupedPosts.keys.sorted(), id: \.self) { key in
                        Section(header: Text(key)) {
                            ForEach(viewModel.groupedPosts[key] ?? [], id: \.id) { post in
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
            .refreshable {
                self.viewModel.fetchPosts(isRefreshing: true)
            }
            
        }
        .padding()
        .background(.aeroBorderSecondary)
    }
    
    @ViewBuilder
    var favoritesButton: some View {
        switch self.viewModel.favoritePosts.isEmpty {
        case false:
            EmptyView()
        case true:
            Image(systemName: "heart.fill")
                .font(.primary(.s18))
                .foregroundStyle(.red)
        }
    }
    
    func itemCard(_ post: PostCellModel, like: @escaping () -> Void) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(post.title.capitalizedFirst).font(.headline)
                Text("User ID: \(post.userID)").font(.subheadline)
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.darkGrey)
            VStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(post.isFavorite ? .red : .gray)
                    .onTapGesture {
                        like()
                    }
                Spacer()
            }
        }
        .padding()
        .innerShadow(color: .PRIMARY, radius: 8, cornerRadius: 12)
    }
}

#Preview {
    HomeListView(viewModel: HomeListViewModel())
}
