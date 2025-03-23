//
//  Tweet.swift
//  Twitter Clone
//
//  Created by mac on 3/23/25.
//
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseCore
import Foundation
import FirebaseFirestore



struct Tweet: Identifiable, Decodable {
    @DocumentID var id: String?
    let caption: String
    let timestamp: Timestamp
    let uid: String
    let likes: Int
    
    var user: User?
    var didLike: Bool? = false
}

