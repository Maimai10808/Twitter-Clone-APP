//
//  AuthViewModel.swift
//  Twitter Clone
//
//  Created by mac on 3/22/25.
//

// 1. 配置Firebase文件， ——>   2.ContentView 配置App环境


import SwiftUI
import Firebase
import FirebaseAuth



class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser = false
    @Published var isUploadingProfileImage = false
    @Published var uploadError: String?
    @Published var currentUser: User?
    
    // 2.AuthViewModel
    private let service = UserService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        print("DEBUG: User session is \(self.userSession?.uid)")
        if let uid = self.userSession?.uid {
            self.fetchUser()
        }
    }
    
    // login 登入功能
    func login(withEmail email : String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            self.didAuthenticateUser = false
            self.fetchUser()
        }
    }
    
    // register 注册功能
    func register(withEmail email: String, password: String, fullname: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            
            guard let firebaseUser = result?.user else { return }
            print("DEBUG: Successfully created user with uid: \(firebaseUser.uid)")
            
            let data = ["email": email,
                       "username": username.lowercased(),
                       "fullname": fullname,
                       "uid": firebaseUser.uid,
                       "profileImageUrl": NSNull()]
            
            Firestore.firestore().collection("users")
                .document(firebaseUser.uid)
                .setData(data) { error in
                    if let error = error {
                        print("DEBUG: Failed to save user data: \(error.localizedDescription)")
                        return
                    }
                    
                    print("DEBUG: Successfully saved user data")
                    self.userSession = firebaseUser
                    self.didAuthenticateUser = true
                    self.fetchUser()
                }
        }
    }
    
    
    func signOut() {
        userSession = nil
        didAuthenticateUser = false
        currentUser = nil
        try? Auth.auth().signOut()
    }
    
    
    
    
    
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
}



// 由于firebase 需要订阅才能解锁上传图片功能，本人财力有限，无奈只能放弃图片上传功能

/*
 func uploadProfileImage(_ image: UIImage) {
     guard let uid = userSession?.uid else {
         self.uploadError = "User session not found"
         return
     }
     
     isUploadingProfileImage = true
     uploadError = nil
     
     ImageUploader.uploadImage(image: image) { [weak self] profileImageUrl in
         guard let self = self else { return }
         
         Firestore.firestore().collection("users")
             .document(uid)
             .updateData(["profileImageUrl": profileImageUrl]) { error in
                 if let error = error {
                     self.uploadError = error.localizedDescription
                     print("DEBUG: Failed to update profile image URL: \(error.localizedDescription)")
                     self.isUploadingProfileImage = false
                     return
                 }
                 
                 print("DEBUG: Successfully updated profile image URL")
                 self.isUploadingProfileImage = false
                 self.didAuthenticateUser = false
                 self.fetchUser()
             }
     }
 }
 
 */
