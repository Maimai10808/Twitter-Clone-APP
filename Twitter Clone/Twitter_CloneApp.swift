//
//  Twitter_CloneApp.swift
//  Twitter Clone
//
//  Created by mac on 3/20/25.
//

import SwiftUI
import Firebase
import FirebaseCore

// 3.Twitter_CloneApp，配置App环境 -->  4.LoginView中和UI结合 
@main
struct Twitter_CloneApp: App {
    
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
        print("DEBUG: Firebase configured successfully")
    }
    
    var body: some Scene {
        WindowGroup {
            
      //      ProfilePhotoSelectorView()
            
          ContentView()
                .environmentObject(viewModel)
        }
    }
}
