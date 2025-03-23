//
//  SideMenuRowView.swift
//  Twitter Clone
//
//  Created by mac on 3/21/25.
//

import SwiftUI

struct SideMenuOptionRowView: View {
    let viewModel: SideMenuViewModel
    var body: some View {
        HStack {
            Image(systemName: viewModel.imageName)
                .font(.headline)
                .foregroundStyle(.gray)
            
            
            
            Text(viewModel.title)
                .foregroundStyle(.black)
                .font(.subheadline)
            
            
            
            Spacer()
        }
        .frame(height: 40)
        .padding(.horizontal)
    }
}





#Preview {
    SideMenuOptionRowView(viewModel: .profile)
}
