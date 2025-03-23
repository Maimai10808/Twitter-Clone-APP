//
//  TweetRowViewModel.swift
//  Twitter Clone
//
//  Created by mac on 3/23/25.
//

import Foundation

class TweetRowViewModel: ObservableObject {
    @Published var tweet: Tweet
    
    private let service = TweetService()
    
    init(tweet: Tweet) {
        self.tweet = tweet
        checkIfUserLikedTweet()
    }
    
    
    func likeTweet() {
        service.likeTweet(tweet) {_ in 
            self.tweet.didLike = true
        }
    }
    
    func unlikeTweet() {
        service.likeTweet(tweet) {_ in 
            self.tweet.didLike = false
        }
    }
    
    
    
    
    func checkIfUserLikedTweet() {
        service.checkIfUserLikedTweet(tweet) { didlike in
            if didlike {
                self.tweet.didLike = true
            }
            
        }
    }
}

