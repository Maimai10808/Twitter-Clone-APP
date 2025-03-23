//
//  TweetService.swift
//  Twitter Clone
//
//  Created by mac on 3/23/25.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import Firebase
import FirebaseFirestore


struct TweetService {
    
    func uploadTweet(caption: String, completion: @escaping(Bool) -> Void)  {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["uid": uid,
                    "caption": caption,
                    "likes": 0,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        
        Firestore.firestore().collection("tweets").document()
            .setData(data) { error in
                if let error = error {
                    print("DEBUG: Failed to upload tweet with error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                print("DEBUG: Successfully uploaded tweet")
                completion(true)
            }
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        print("DEBUG: Fetching all tweets...")
        Firestore.firestore().collection("tweets")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("DEBUG: Failed to fetch tweets with error: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("DEBUG: No documents found")
                    return
                }
                
                print("DEBUG: Found \(documents.count) tweets")
                let tweets = documents.compactMap({ try? $0.data(as: Tweet.self)})
                print("DEBUG: Successfully decoded \(tweets.count) tweets")
                completion(tweets)
            }
    }
    
    func fetchTweets(forUid uid: String, completion: @escaping([Tweet]) -> Void) {
        print("DEBUG: Fetching tweets for user \(uid)...")
        
        // 临时解决方案：先获取所有推文，然后在内存中过滤
        Firestore.firestore().collection("tweets")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("DEBUG: Failed to fetch tweets with error: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("DEBUG: No documents found")
                    return
                }
                
                print("DEBUG: Found \(documents.count) total tweets")
                let allTweets = documents.compactMap({ try? $0.data(as: Tweet.self)})
                let userTweets = allTweets.filter { $0.uid == uid }
                print("DEBUG: Found \(userTweets.count) tweets for user \(uid)")
                completion(userTweets)
            }
    }
    
    func likeTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        
        let userLikesRef = Firestore.firestore().collection("users").document(uid).collection("user-likes")
        
        userLikesRef.document(tweetId).getDocument { snapshot, _ in
            if let snapshot = snapshot, snapshot.exists {
                // 如果已经点赞，则取消点赞
                userLikesRef.document(tweetId).delete { _ in
                    Firestore.firestore().collection("tweets").document(tweetId).updateData([
                        "likes": FieldValue.increment(Int64(-1))
                    ]) { _ in
                        completion(false)
                    }
                }
            } else {
                // 如果未点赞，则添加点赞
                userLikesRef.document(tweetId).setData([:]) { _ in
                    Firestore.firestore().collection("tweets").document(tweetId).updateData([
                        "likes": FieldValue.increment(Int64(1))
                    ]) { _ in
                        completion(true)
                    }
                }
            }
        }
    }
    
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        
        Firestore.firestore().collection("users").document(uid).collection("user-likes").document(tweetId).getDocument { snapshot, _ in
            completion(snapshot?.exists ?? false)
        }
    }
    
    func fetchLikedTweets(forUid uid: String, completion: @escaping([Tweet]) -> Void) {
        print("DEBUG: Fetching liked tweets for user \(uid)")
        
        // 1. 首先获取用户点赞的推文ID
        Firestore.firestore().collection("users")
            .document(uid)
            .collection("user-likes")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("DEBUG: Failed to fetch liked tweets with error: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("DEBUG: No liked tweets found")
                    completion([])
                    return
                }
                
                print("DEBUG: Found \(documents.count) liked tweets")
                
                // 2. 获取所有点赞的推文ID
                let tweetIDs = documents.map { $0.documentID }
                
                // 3. 获取每个推文的详细信息
                var tweets = [Tweet]()
                let group = DispatchGroup()
                
                for tweetID in tweetIDs {
                    group.enter()
                    
                    Firestore.firestore().collection("tweets")
                        .document(tweetID)
                        .getDocument { snapshot, error in
                            defer { group.leave() }
                            
                            if let error = error {
                                print("DEBUG: Failed to fetch tweet \(tweetID) with error: \(error.localizedDescription)")
                                return
                            }
                            
                            if let tweet = try? snapshot?.data(as: Tweet.self) {
                                tweets.append(tweet)
                            }
                        }
                }
                
                group.notify(queue: .main) {
                    completion(tweets)
                }
            }
    }
    
    
}



/*
 
 
 
 */
