//
//  UserRowView.swift
//  Twitter Clone
//
//  Created by mac on 3/21/25.
//

import SwiftUI

struct UserRowView: View {
    let user: User
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 48, height: 48)
            VStack(alignment: .leading, spacing: 4) {
                Text(user.username)
                    .font(.subheadline).bold()
                    .foregroundColor(.black)
                
                Text(user.fullname)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}


