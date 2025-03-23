//
//  UserService.swift
//  Twitter Clone
//
//  Created by mac on 3/22/25.
//

import Firebase
import FirebaseFirestore

// 1. 设置API获取service ——> 2. AuthViewModel

struct UserService {
    
    // 获取单个用户信息
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        print("DEBUG: UserService fetching user with uid: \(uid)")
        
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    print("DEBUG: Error fetching user data: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("DEBUG: No snapshot returned")
                    return
                }
                
                print("DEBUG: Document exists: \(snapshot.exists)")
                
                guard let user = try? snapshot.data(as: User.self) else {
                    print("DEBUG: Failed to decode user data")
                    return
                }
                
                print("DEBUG: Successfully fetched user: \(user.username)")
                completion(user)
            }
    }
    
    // 获取所有用户信息
    func fetchUsers(completion: @escaping([User]) -> Void) {
        // 初始化一个空的数组，用来存放获取到的用户数据
        var users = [User]()
        
        // 获取 Firestore 中 "users" 集合的数据
        Firestore.firestore().collection("users")
            // 通过 .getDocuments() 获取所有文档
            .getDocuments { snapshot, error in
                // 如果获取文档失败，直接返回
                guard let documents = snapshot?.documents else { return }
                
                // 遍历所有文档
                documents.forEach { document in
                    // 尝试将文档数据解析为 User 类型，如果失败则跳过当前文档
                    guard let user = try? document.data(as: User.self) else { return }
                    
                    // 将成功解析的 User 添加到数组中
                    users.append(user)
                }
                
                // 所有用户数据获取并解析完毕后，执行 completion 回调，并将用户数据数组传递出去
                completion(users)
            }
    }
}
