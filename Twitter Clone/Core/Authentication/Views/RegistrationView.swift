//
//  RegistrationView.swift
//  Twitter Clone
//
//  Created by mac on 3/21/25.
//
import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                AuthHeaderView(title1: "Get started", title2: "Create your account")

                VStack(spacing: 20) {
                    CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                    CustomInputField(imageName: "person", placeholderText: "Username", text: $username)
                    CustomInputField(imageName: "person", placeholderText: "Full name", text: $fullname)
                    CustomInputField(imageName: "lock", placeholderText: "Password", text: $password)
                }
                .padding(.horizontal, 32)
                .padding(.top, 20)

                Button {
                    print("DEBUG: Sign up tapped")
                    viewModel.register(withEmail: email, password: password, fullname: fullname, username: username)
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x:0, y:0)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Already have an account?")
                            .font(.footnote)
                        Text("Sign In")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 32)
                .foregroundStyle(Color(.systemBlue))
            }
            .navigationDestination(isPresented: $viewModel.didAuthenticateUser) {
                ProfilePhotoSelectorView()
                    .environmentObject(viewModel)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RegistrationView()
}
