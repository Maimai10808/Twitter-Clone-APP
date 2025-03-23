//
//  ProfilePhotoSelectorView.swift
//  Twitter Clone
//
//  Created by mac on 3/22/25.
//

import SwiftUI
import PhotosUI

struct ProfilePhotoSelectorView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var photoPickerItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            AuthHeaderView(title1: "Create your account", title2: "Select a profile photo")
            
            PhotosPicker(selection: $photoPickerItem,
                        matching: .images) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .padding(.top, 44)
                } else {
                    Image("plus_photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .padding(.top, 44)
                }
            }
            
            if viewModel.isUploadingProfileImage {
                ProgressView("Uploading profile image...")
                    .padding(.top, 20)
            }
            
            if let error = viewModel.uploadError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 20)
            }
            
            if selectedImage != nil {
                Button {
                    print("由于firebase 需要订阅才能解锁上传图片功能，本人财力有限，无奈只能放弃图片上传功能")
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding(.top, 20)
                }
                .disabled(viewModel.isUploadingProfileImage)
            }
            
            Spacer()
        }
        .onChange(of: photoPickerItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        selectedImage = image
                    }
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ProfilePhotoSelectorView()
        .environmentObject(AuthViewModel())
}
