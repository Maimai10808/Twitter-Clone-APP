import Foundation
import Firebase
import FirebaseAuth


class ProfileViewModel: ObservableObject {
    @Published var tweets = [Tweet]()
    @Published var likedTweets = [Tweet]() // 存储用户喜欢的推文
    @Published var isFollowing: Bool = false // 是否已关注该用户
    
    let service = TweetService()
    let userService = UserService()
    
    var user: User? // 用来保存当前的 `User` 对象
    
    // 计算属性，根据是否是当前用户来设置按钮标题
    var actionButtonTitle: String {
        guard let user = user else {
            return "Follow" // 如果没有用户信息，就显示“Follow”按钮
        }
        return user.isCurrentUser ? "Edit Profile" : (isFollowing ? "Unfollow" : "Follow")
    }
    
    func fetchUserTweets(forUid uid: String) {
        print("DEBUG: Fetching tweets for user \(uid)")
        service.fetchTweets(forUid: uid) { tweets in
            self.tweets = tweets
            for i in 0 ..< tweets.count {
                let uid = tweets[i].uid
                self.userService.fetchUser(withUid: uid) { user in
                    self.tweets[i].user = user
                }
            }
        }
    }
    
    // 获取用户喜欢的推文
    func fetchLikedTweets(forUid uid: String) {
        print("DEBUG: Fetching liked tweets for user \(uid)")
        service.fetchLikedTweets(forUid: uid) { tweets in
            self.likedTweets = tweets
            for i in 0 ..< tweets.count {
                let uid = tweets[i].uid
                self.userService.fetchUser(withUid: uid) { user in
                    self.likedTweets[i].user = user
                }
            }
        }
    }
    
    // 关注该用户
    func followUser() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        guard let userIdToFollow = user?.id else { return }
        
        // 更新数据库：将该用户加入当前用户的“关注”列表
        Firestore.firestore().collection("users").document(currentUserId).collection("following").document(userIdToFollow).setData([:]) { error in
            if let error = error {
                print("DEBUG: Failed to follow user: \(error.localizedDescription)")
                return
            }
            self.isFollowing = true
            print("DEBUG: Successfully followed user.")
        }
    }
    
    // 取消关注该用户
    func unfollowUser() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        guard let userIdToUnfollow = user?.id else { return }
        
        // 更新数据库：将该用户从当前用户的“关注”列表中移除
        Firestore.firestore().collection("users").document(currentUserId).collection("following").document(userIdToUnfollow).delete { error in
            if let error = error {
                print("DEBUG: Failed to unfollow user: \(error.localizedDescription)")
                return
            }
            self.isFollowing = false
            print("DEBUG: Successfully unfollowed user.")
        }
    }
    
    // 检查当前用户是否已关注该用户
    func checkIfUserIsFollowing() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.id else { return }
        
        Firestore.firestore().collection("users").document(currentUserId).collection("following").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("DEBUG: Failed to check following status: \(error.localizedDescription)")
                return
            }
            self.isFollowing = snapshot?.exists ?? false
        }
    }
}
