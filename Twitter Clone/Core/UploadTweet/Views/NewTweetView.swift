//
//  NewTweetView.swift
//  Twitter Clone
//
//  Created by mac on 3/21/25.
//

import SwiftUI

struct NewTweetView: View {
    
    @State private var caption = ""
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject var viewModel = UploadTweetViewModel()
    
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(Color(.systemBlue))
                }
                
                Spacer()
                
                Button {
                    viewModel.uploadTweet(withCaption: caption)
                } label: {
                    Text("Tweet")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemBlue))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            
            HStack(alignment: .top) {
                Circle()
                    .frame(width: 64, height: 64)
                
                TextArea("What's happening?", text: $caption)
               }
            .padding()
                
            }
        .onReceive(viewModel.$didUploadTweet) { success in
            if success {
                dismiss()
            }
            
        }
        
        }
    }

#Preview {
    NewTweetView()
}
