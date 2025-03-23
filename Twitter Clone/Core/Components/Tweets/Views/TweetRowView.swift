//
//  TweetRowView.swift
//  Twitter Clone
//
//  Created by mac on 3/20/25.
//

import SwiftUI

struct TweetRowView: View {
    let tweet: Tweet
    @ObservedObject var viewModel: TweetRowViewModel
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.viewModel = TweetRowViewModel(tweet: tweet)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let user = tweet.user {
                // profile image + uesr info + tweet
                
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .frame(width: 56, height: 56)
                        .foregroundColor(Color(.systemBlue))
                    
                    // user info & tweet caption
                    
                    VStack{
                        
                        
                        HStack {
                            
                            // user info
                            Text(user.fullname)
                                .font(.subheadline).bold()
                            
                            Text("@\(user.username)")
                                .foregroundColor(.gray)
                                .font(.caption)
                            
                            Text("2w")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        
                        //  tweet caption
                        Text(tweet.caption)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            // action buttons
            
            HStack {
                
                Button {
                    
                } label: {
                    Image(systemName: "bubble.left")
                        .font(.subheadline)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.2.squarepath")
                        .font(.subheadline)
                }
                
                Spacer()
                
                Button {
                    if viewModel.tweet.didLike ?? false {
                        viewModel.unlikeTweet()
                    } else {
                        viewModel.likeTweet()
                    }
                } label: {
                    Image(systemName: viewModel.tweet.didLike ?? false ? "heart.fill" : "heart")
                        .font(.subheadline)
                        .foregroundColor(viewModel.tweet.didLike ?? false ? .red : .gray)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "bookmark")
                        .font(.subheadline)
                }
                
                
                
                
            }
            .padding()
            .foregroundColor(.gray)
            
            Divider()
        }
    }
}


