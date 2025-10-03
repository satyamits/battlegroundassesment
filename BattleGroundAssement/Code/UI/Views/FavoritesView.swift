import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: HomeListViewModel
    
    var body: some View {
        List(viewModel.favoritePosts) { post in
            NavigationLink {
                PostDetailView(post: post) {
                    viewModel.toggleFavorite(for: post)
                }
            } label: {
                VStack(alignment: .leading) {
                    Text(post.title).font(.headline)
                    Text("User ID: \(post.userID)").font(.subheadline)
                }
            }
        }
        .navigationTitle("Favorites")
    }
}
