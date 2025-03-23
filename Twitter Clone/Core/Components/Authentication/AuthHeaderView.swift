//
//  AuthHeaderView.swift
//  Twitter Clone
//
//  Created by mac on 3/21/25.
//

import SwiftUI

struct AuthHeaderView: View {
    
    let title1: String
    let title2: String
    var body: some View {
        // header view
        VStack(alignment: .leading) {
            HStack { Spacer() }
            
            Text(title1)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text(title2)
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
        .frame(height: 260)
        .padding(.leading)
        .background(Color(.systemBlue))
        .foregroundStyle(.white)
        .clipShape(RoundedShape(corners: [.bottomRight]))
    }
}

#Preview {
    AuthHeaderView(title1: "Title1", title2: "Title2")
}
