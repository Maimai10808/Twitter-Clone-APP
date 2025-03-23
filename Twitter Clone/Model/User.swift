//
//  User.swift
//  Twitter Clone
//
//  Created by mac on 3/23/25.
//

import FirebaseFirestore
import Firebase
import FirebaseAuth




struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let fullname: String
    let profileImageUrl: String?
    let email: String
    
    // 计算属性，判断是否为当前用户
        var isCurrentUser: Bool {
            return self.id == Auth.auth().currentUser?.uid
        }
}
