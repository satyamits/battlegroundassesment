import SwiftUI

struct PostDetailView: View {
    let post: PostCellModel
    let toggleFavorite: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(post.title)
                    .font(.title)
                    .bold()
                
                Text(post.body)
                    .font(.body)
                
                Button(action: toggleFavorite) {
                    Label(post.isFavorite ? "Unfavorite" : "Favorite",
                          systemImage: post.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(post.isFavorite ? .red : .blue)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle("Post Detail")
    }
}
