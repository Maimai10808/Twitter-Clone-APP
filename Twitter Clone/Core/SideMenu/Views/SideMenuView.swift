//
//  SideMenuView.swift
//  Twitter Clone
//
//  Created by mac on 3/21/25.
//
import SwiftUI
import Kingfisher

struct SideMenuView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            // 用户信息视图
            Spacer()
            
            if let user = authViewModel.currentUser {
                
                VStack(alignment: .center, spacing: 30) {
                    // 头像
                    KFImage(URL(string: user.profileImageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 70, height: 70)
                        .shadow(radius: 10) // 添加阴影效果
                        .padding(.bottom, 8)
                    
                    // 用户名和全名
                    VStack(alignment: .center, spacing: 4) {
                        Text(user.fullname)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(user.username)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 16)
                    
                    // 用户统计信息
                    UserStatsView()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal) // 外边距
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5) // 给整体添加阴影
                
                Spacer()
            } else {
                // 默认用户信息视图
                VStack(alignment: .center, spacing: 12) {
                    Circle()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray.opacity(0.2))
                        .padding(.bottom, 8)
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("Loading...")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Please wait")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 16)
                    
                    UserStatsView()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
                
                Spacer()
            }
            
            // Side menu options
            ForEach(SideMenuViewModel.allCases, id: \.self) { viewModel in
                
                if viewModel == .profile {
                    if let user = authViewModel.currentUser {
                        NavigationLink {
                            ProfileView(user: user)
                        } label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }
                    } else {
                        SideMenuOptionRowView(viewModel: viewModel)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .opacity(0.5)
                    }
                } else if viewModel == .logout {
                    Button {
                        authViewModel.signOut()
                    } label: {
                        SideMenuOptionRowView(viewModel: viewModel)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                } else {
                    SideMenuOptionRowView(viewModel: viewModel)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
            }
            Spacer()
        }
        .padding(.top, 20)
        .padding(.horizontal, 16) // 为内容添加一些额外的水平内边距，使内容不紧贴边缘
        .background(Color(UIColor.systemGray6)) // 背景颜色
        .cornerRadius(20) // 圆角
        .edgesIgnoringSafeArea(.all) // 防止内容被安全区域遮挡
    }
}

#Preview {
    SideMenuView()
        .environmentObject(AuthViewModel())
}
