//
//  ImageUploader.swift
//  Twitter Clone
//
//  Created by mac on 3/22/25.
//


// 由于firebase 需要订阅才能解锁上传图片功能，本人财力有限，无奈只能放弃图片上传功能

/*
import Foundation
import Firebase
import FirebaseStorage
import UIKit
import FirebaseAuth


struct ImageUploader {
    
    static func uploadImage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("DEBUG: Failed to convert image to data")
            return
        }
        
        // 使用用户 UID 创建路径，确保每个用户的头像存储在独立的路径下
        let filename = NSUUID().uuidString
        let uid = Auth.auth().currentUser?.uid ?? UUID().uuidString
        let ref = Storage.storage().reference().child("profile_image/\(uid)/\(filename)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        print("DEBUG: Starting image upload to path: \(ref.fullPath)")
        
        ref.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: Successfully uploaded image data")
            
            ref.downloadURL { imageUrl, error in
                if let error = error {
                    print("DEBUG: Failed to get download URL with error: \(error.localizedDescription)")
                    return
                }
                
                guard let imageUrl = imageUrl?.absoluteString else {
                    print("DEBUG: Failed to get image URL string")
                    return
                }
                
                print("DEBUG: Successfully got download URL: \(imageUrl)")
                completion(imageUrl)
            }
        }
    }
}
 
*/
