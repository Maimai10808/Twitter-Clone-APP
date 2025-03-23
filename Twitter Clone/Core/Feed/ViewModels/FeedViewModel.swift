//
//  FeedViewModel.swift
//  Twitter Clone
//
//  Created by mac on 3/23/25.
//

import Foundation

class FeedViewModel: ObservableObject {
    
    
    @Published var tweets = [Tweet]()
    let service = TweetService()
    let userService = UserService()
    init() {
        print("DEBUG: FeedViewModel initialized")
        fetchTweets()
    }
    
    func fetchTweets() {
        print("DEBUG: FeedViewModel fetching tweets")
        service.fetchTweets { tweets in
            print("DEBUG: FeedViewModel received \(tweets.count) tweets")
            self.tweets = tweets
            
            for i in 0 ..< tweets.count {
                let uid = tweets[i].uid
                print("DEBUG: Fetching user info for tweet \(i) with uid \(uid)")
                
                self.userService.fetchUser(withUid: uid) { user in
                    print("DEBUG: Received user info for tweet \(i)")
                    DispatchQueue.main.async {
                        self.tweets[i].user = user
                    }
                }
            }
            
        }
    }
    
}

