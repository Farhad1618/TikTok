//
//  ProfileHeaderView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    @State private var showEditProfile = false
    @ObservedObject var viewModel: ProfileViewModel
    
    private var user: User {
        return viewModel.user
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                CircularProfileImageView(user: user, size: .xLarge)
                
                Text("@\(user.username)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            // stats view
            HStack(spacing: 16) {
                UserStatView(value: user.stats.following, title: "Following")
                
                UserStatView(value: user.stats.followers, title: "Followers")
                
                UserStatView(value: user.stats.likes, title: "Likes")
            }
            
            // action button view
            if user.isCurrentUser {
                Button {
                    showEditProfile.toggle()
                } label: {
                    Text("Edit Profile")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 360, height: 32)
                        .foregroundStyle(.black)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            } else {
                Button {
                    handleFollowTapped()
                } label: {
                    Text(user.isFollowed ? "Following" : "Follow")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 32)
                        .foregroundStyle(user.isFollowed ? .black : .white)
                        .background(user.isFollowed ? .white : .pink)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .overlay {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: user.isFollowed ? 1 : 0)
                        }
                }
            }
            
            // bio
            if let bio = user.bio {
                Text(bio)
                    .font(.subheadline)
            }
            
            Divider()
        }
        .fullScreenCover(isPresented: $showEditProfile) {
            EditProfileView(user: $viewModel.user)
        }
    }
    
    func handleFollowTapped() {
        user.isFollowed ? viewModel.unfollow() : viewModel.follow()
    }
}

struct UserStatView: View {
    let value: Int
    let title: String
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.subheadline)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .opacity(value == 0 ? 0.5 : 1.0)
        .frame(width: 80, alignment: .center)
    }
}

#Preview {
    ProfileHeaderView(viewModel: ProfileViewModel(
        user: DeveloperPreview.user,
        userService: UserService(),
        postService: PostService())
    )
}
