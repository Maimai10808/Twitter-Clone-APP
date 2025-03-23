//
//  ProfileView.swift
//  Twitter Clone
//
//  Created by mac on 3/20/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedFilter: TweetFilterViewModel = .tweets
    @Namespace var animation
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ProfileViewModel()
    
    let user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            headerView
            actionButtons
            userInfoDetails
            tweetFilterBar
            tweetsView
            Spacer()
        }
        .onAppear {
            viewModel.fetchUserTweets(forUid: user.id ?? "")
            viewModel.fetchLikedTweets(forUid: user.id ?? "")
            viewModel.user = user // Set the user to ProfileViewModel
            viewModel.checkIfUserIsFollowing() // Check if the current user is following
        }
    }
    
    // Action button view
    var actionButtons: some View {
        HStack {
            Spacer()
            
            // Follow / Unfollow button
            Button {
                if viewModel.isFollowing {
                    viewModel.unfollowUser() // If the user is already following, unfollow
                } else {
                    viewModel.followUser() // If the user is not following, follow
                }
            } label: {
                Text(viewModel.actionButtonTitle) // Dynamically change the button title
                    .font(.subheadline).bold()
                    .frame(width: 120, height: 32)
                    .foregroundColor(.black)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 0.75))
            }
        }
        .padding(.trailing)
    }
    
    // Header View
    var headerView: some View {
        ZStack(alignment: .bottomLeading) {
            Color(.systemBlue)
                .ignoresSafeArea()
            VStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 16)
                        .foregroundColor(.white)
                        .offset(x:16, y:12)
                }
                Circle()
                    .frame(width: 72, height: 72)
                    .offset(x:16, y: 24)
            }
        }
        .frame(height: 96)
    }
    
    // User Info details (name, username, etc.)
    var userInfoDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(user.fullname)
                    .font(.title2).bold()
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Color(.systemBlue))
            }
            Text(user.email)
                .font(.subheadline)
                .padding(.vertical)
            UserStatsView()
            .padding(.vertical)
        }
        .padding(.horizontal)
    }
    
    // Tweet Filter Bar (for toggling between tweets and liked tweets)
    var tweetFilterBar: some View {
        HStack {
            ForEach(TweetFilterViewModel.allCases, id: \.rawValue) { item in
                VStack {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(selectedFilter == item ? .semibold : .regular)
                        .foregroundColor(selectedFilter == item ? .black : .gray)
                    if selectedFilter == item {
                        Capsule()
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)
                    } else {
                        Capsule()
                            .foregroundColor(Color(.clear))
                            .frame(height: 3)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedFilter = item
                    }
                }
            }
        }
        .overlay(Divider().offset(x:0, y:16))
    }
    
    // Tweets view (shows either user's tweets or liked tweets based on filter)
    var tweetsView: some View {
        ScrollView {
            LazyVStack {
                ForEach(selectedFilter == .tweets ? viewModel.tweets : viewModel.likedTweets) { tweet in
                    TweetRowView(tweet: tweet)
                        .padding()
                }
            }
        }
    }
}
