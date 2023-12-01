//
//  ProfileView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    private var user: User {
        return viewModel.user
    }
    
    init(user: User) {
        let profileViewModel = ProfileViewModel(user: user, 
                                                userService: UserService(),
                                                postService: PostService())
        self._viewModel = StateObject(wrappedValue: profileViewModel)
        
        UINavigationBar.appearance().tintColor = .primaryText
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 2) {
                ProfileHeaderView(viewModel: viewModel)
                
                PostGridView(viewModel: viewModel)
            }
        }
        .task { await viewModel.fetchUserPosts() }
        .task { await viewModel.checkIfUserIsFollowed() }
        .task { await viewModel.fetchUserStats() }
        .navigationTitle(user.username)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.primaryText)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ProfileView(user: DeveloperPreview.user)
}
