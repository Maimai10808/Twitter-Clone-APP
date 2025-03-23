//
//  FeedView.swift
//  Twitter Clone
//
//  Created by mac on 3/20/25.
//

import SwiftUI

struct FeedView: View {
    @State private var showNewTweetView = false
    @ObservedObject var viewModel = FeedViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.tweets) { tweet in
                        TweetRowView(tweet: tweet)
                            .padding()
                    }
                }
            }
            
            Button {
                showNewTweetView.toggle()
            } label: {
                Image("Pen")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                    .padding()
                    .overlay(
                        Circle() // 创建圆形边框
                            .stroke(Color(.systemBlue), lineWidth: 2) // 设置边框颜色和宽度
                    )
            }
            .foregroundStyle(Color(.systemBlue))
            .clipShape(Circle())
            .padding()
            .fullScreenCover(isPresented: $showNewTweetView) {
                NewTweetView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("DEBUG: FeedView appeared")
            viewModel.fetchTweets()
        }
    }
}




#Preview {
    FeedView()
}
