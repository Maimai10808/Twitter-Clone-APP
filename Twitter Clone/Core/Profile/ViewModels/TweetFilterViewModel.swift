//
//  TweetFilterViewModel.swift
//  Twitter Clone
//
//  Created by mac on 3/20/25.
//

import Foundation


enum TweetFilterViewModel: String, CaseIterable {
    case tweets = "Tweets"
    case likedTweets = "Liked Tweets" // 添加 likedTweets 选项
    
    var title: String {
        switch self {
        case .tweets: return "Tweets"
        case .likedTweets: return "Liked Tweets"
        }
    }
}
