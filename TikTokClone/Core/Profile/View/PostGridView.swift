//
//  PostGridView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI
import Kingfisher
import AVKit

struct PostGridView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var player = AVPlayer()
    @State private var selectedPost: Post?
    
    private let items = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
    ]
    private let width = (UIScreen.main.bounds.width / 3) - 2
    
    var body: some View {
        LazyVGrid(columns: items, spacing: 2) {
            ForEach(viewModel.posts) { post in
                KFImage(URL(string: post.thumbnailUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: 160)
                    .clipped()
                    .onTapGesture { selectedPost = post }
            }
        }
        .sheet(item: $selectedPost) { post in
            FeedView(player: $player, posts: [post])
                .onDisappear {
                    player.replaceCurrentItem(with: nil)
                }
        }
    }
}

#Preview {
    PostGridView(viewModel: ProfileViewModel(
        user: DeveloperPreview.user,
        userService: UserService(),
        postService: PostService())
    )
}
