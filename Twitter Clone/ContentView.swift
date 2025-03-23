//
//  ContentView.swift
//  Twitter Clone
//
//  Created by mac on 3/20/25.
//

import SwiftUI

struct ContentView: View {
    
    //  2.ContentView 配置App环境 ——》 3.Twitter_CloneApp，配置App环境
    
    @State private var showMenu = false
    //
    @EnvironmentObject var viewModel: AuthViewModel
    //
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
            } else if viewModel.didAuthenticateUser {
                ProfilePhotoSelectorView()
            } else {
                mainInterfaceView
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}

extension ContentView {
    var mainInterfaceView: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                MainTabView()
                    .navigationBarHidden(showMenu)
                
                if showMenu {
                    ZStack {
                        Color(.black)
                            .opacity(showMenu ? 0.25 : 0.0)
                    }.onTapGesture {
                        withAnimation(.easeInOut) {
                            showMenu = false
                        }
                    }
                    .ignoresSafeArea()
                }
                SideMenuView()
                    .frame(width: 300)
                    .offset(x: showMenu ? 0 : -300, y: 0)
                    .background(showMenu ? Color.white : Color.clear)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation(.easeInOut) {
                            showMenu.toggle()
                        }
                    } label: {
                        Circle()
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .onAppear {
                showMenu = false
            }
        }
    }
}
