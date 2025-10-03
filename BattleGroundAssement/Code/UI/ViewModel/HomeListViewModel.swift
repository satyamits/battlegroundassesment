//
//  HomeListViewModel.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 01/10/25.
//

import Foundation

@MainActor
final class HomeListViewModel: SUIBaseViewModel {
    
    @Published var posts: [PostCellModel] = []
    @Published var favoritePosts: [PostCellModel] = []
    
    @Published var allPosts: [PostCellModel] = []
    
    @Published var searchText: String = ""
    @Published var favSearchText: String = ""
    
    override init() {
        super.init()
        Task { @MainActor in
            self.fetchPosts()
        }
        
    }
    
    var groupedPosts: [String: [PostCellModel]] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            let grouped = Dictionary(grouping: allPosts) {
                String($0.title.prefix(1).uppercased())
            }
            return grouped
                .mapValues { $0.sorted { $0.title < $1.title } }
                .sorted(by: { $0.key < $1.key })
                .reduce(into: [String: [PostCellModel]]()) { $0[$1.key] = $1.value }
        }
        
        let lowerQuery = query.lowercased()
        // Ranked lists
        let exactMatches = allPosts.filter { $0.title.lowercased() == lowerQuery }
        let startsWithMatches = allPosts.filter {
            let lower = $0.title.lowercased()
            return lower.hasPrefix(lowerQuery) && lower != lowerQuery
        }.sorted { $0.title < $1.title }
        let containsMatches = allPosts.filter {
            let lower = $0.title.lowercased()
            return lower.contains(lowerQuery) && !lower.hasPrefix(lowerQuery) && lower != lowerQuery
        }.sorted { $0.title < $1.title }
        
        // Combined result preserving rank order
        let ranked = exactMatches + startsWithMatches + containsMatches
        
        let grouped = Dictionary(grouping: ranked) {
            String($0.title.prefix(1).uppercased())
        }
        
        return grouped
            .mapValues { $0 }
            .sorted(by: { $0.key < $1.key })
            .reduce(into: [String: [PostCellModel]]()) { $0[$1.key] = $1.value }
    }
    
    // Grouped search logic for favorites
    var groupedFavoritePosts: [String: [PostCellModel]] {
        let query = favSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            let grouped = Dictionary(grouping: favoritePosts) {
                String($0.title.prefix(1).uppercased())
            }
            return grouped
                .mapValues { $0.sorted { $0.title < $1.title } }
                .sorted(by: { $0.key < $1.key })
                .reduce(into: [String: [PostCellModel]]()) { $0[$1.key] = $1.value }
        }
        
        let lowerQuery = query.lowercased()
        
        let exactMatches = favoritePosts.filter { $0.title.lowercased() == lowerQuery }
        let startsWithMatches = favoritePosts.filter {
            let lower = $0.title.lowercased()
            return lower.hasPrefix(lowerQuery) && lower != lowerQuery
        }.sorted { $0.title < $1.title }
        let containsMatches = favoritePosts.filter {
            let lower = $0.title.lowercased()
            return lower.contains(lowerQuery) && !lower.hasPrefix(lowerQuery) && lower != lowerQuery
        }.sorted { $0.title < $1.title }
        
        let ranked = exactMatches + startsWithMatches + containsMatches
        
        let grouped = Dictionary(grouping: ranked) {
            String($0.title.prefix(1).uppercased())
        }
        
        return grouped
            .mapValues { $0 }
            .sorted(by: { $0.key < $1.key })
            .reduce(into: [String: [PostCellModel]]()) { $0[$1.key] = $1.value }
    }
    
    let client: PostClientProtocol = PostClient()

    func toggleFavorite(for post: PostCellModel) {
        var message: String = ""
        
        if let index = allPosts.firstIndex(where: { $0.id == post.id }) {
            allPosts[index].isFavorite.toggle()
            message = allPosts[index].isFavorite ? "Added to Favorites ❤️" : "Removed from Favorites 💔"
        }
        
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].isFavorite.toggle()
        }
        
        favoritePosts = allPosts.filter { $0.isFavorite }
        
        // Trigger snackbar
        
        
        // Auto dismiss snackbar after 2s
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.showSnackbar(title: "Favorites Updated", message: message, icon: .success)
        }
    }

}

extension HomeListViewModel {
    
    func fetchPosts() {
        Task { [weak self] in
        guard let self else { return }
            await self._fetchPosts()
        }
    }
    
    func _fetchPosts() async {
        self.showLoader()
        defer { self.hideLoader() }
        do {
            let result = try await client.fetchPosts()
            DispatchQueue.main.async {
                self.allPosts = result.compactMap { post in
                    guard let userID = post.userID, let id = post.id,
                        let title = post.title, let body = post.body else { return nil }
                    return PostCellModel(userID: userID, id: id, title: title, body: body)
                }
                self.posts = self.allPosts
            }
        } catch(let error) {
            self.handleError(withError: error)
        }
    }
}
