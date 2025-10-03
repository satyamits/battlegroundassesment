//
//  ContentView.swift
//  BattleGroundAssement
//
//  Created by Satyam Singh on 01/10/25.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = HomeListViewModel()
    
    var body: some View {
        TabView {
            NavigationView {
                HomeListView(viewModel: viewModel)
            }
            .tabItem {
                Label("Posts", systemImage: "list.bullet")
            }
            
            NavigationView {
                FavoritesView(viewModel: viewModel)
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
        }
        .bindLoader(isLoading: self.viewModel.isLoading)
        .snackbarView(snackbar: self.$viewModel.snackbar)
        .bindTextLoader(isLoading: self.viewModel.isLoading, text: "Please wait while we fetching data..")
    }
}


#Preview {
    ContentView()
}
