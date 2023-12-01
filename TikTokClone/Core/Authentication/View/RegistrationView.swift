//
//  RegistrationView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/10/23.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    
    init(service: AuthService) {
        self._viewModel = StateObject(wrappedValue: RegistrationViewModel(service: service))
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            // logo image
            Image("tiktok-app-icon")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
            
            // text fields
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(StandardTextFieldModifier())
                
                SecureField("Enter your password", text: $viewModel.password)
                    .modifier(StandardTextFieldModifier())
                
                TextField("Enter your full name", text: $viewModel.fullname)
                    .autocapitalization(.none)
                    .modifier(StandardTextFieldModifier())
                
                TextField("Enter your username", text: $viewModel.username)
                    .autocapitalization(.none)
                    .modifier(StandardTextFieldModifier())
            }
            
            Button {
                Task { try await viewModel.createUser() }
            } label: {
                Text(viewModel.isAuthenticating ? "" : "Sign up")
                    .modifier(StandardButtonModifier())
                    .overlay {
                        if viewModel.isAuthenticating {
                            ProgressView()
                                .tint(.white)
                        }
                    }
                    
            }
            .disabled(viewModel.isAuthenticating || !formIsValid)
            .opacity(formIsValid ? 1 : 0.7)
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    
                    Text("Sign in")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.authError?.description ?? ""))
        }
    }
}

// MARK: - Form Validation

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
        && !viewModel.fullname.isEmpty
        && viewModel.password.count > 5
    }
}

#Preview {
    RegistrationView(service: AuthService())
}
