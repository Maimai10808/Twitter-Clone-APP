//
//  ExploreView.swift
//  Twitter Clone
//
//  Created by mac on 3/20/25.
//

import SwiftUI

struct ExploreView: View {
    
    @ObservedObject var viewModel = ExploreViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                SearchBar(text: $viewModel.searchText)
                    .padding()
                
                LazyVStack {
                    // 使用 LazyVStack 提高性能并确保 NavigationLink 正常工作
                    ForEach(viewModel.searchableUsers) { user in
                        NavigationLink(destination: ProfileView(user: user)) {
                            // 确保整个行都是可点击的
                            UserRowView(user: user)
                        }
                    }
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ExploreView()
}
