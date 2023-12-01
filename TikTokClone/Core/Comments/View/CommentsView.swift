//
//  CommentsView.swift
//  TikTokClone
//
//  Created by Farhad on 10/9/23.
//

import SwiftUI

struct CommentsView: View {
    @StateObject var viewModel: CommentViewModel
    
    init(post: Post) {
        let service = CommentService(post: post, userService: UserService())
        let viewModel = CommentViewModel(post: post, service: service)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if !viewModel.comments.isEmpty {
                Text(viewModel.commentCountText)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.top, 24)
            }
            
            Divider()
            
            List {
                VStack(spacing: 24) {
                    ForEach(viewModel.comments) { comment in
                        CommentCell(comment: comment)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            
            Divider()
                .padding(.bottom)
            
            HStack(spacing: 12) {
                CircularProfileImageView(user: viewModel.currentUser, size: .xSmall)
                
                CommentInputView(viewModel: viewModel)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .overlay {
            if viewModel.showEmptyView {
                ContentUnavailableView("No comments yet. Add yours now!", systemImage: "exclamationmark.bubble")
                    .foregroundStyle(.gray)
            }
        }
        .task { await viewModel.fetchComments() }
    }
}

#Preview {
    CommentsView(post: DeveloperPreview.posts[0])
}
