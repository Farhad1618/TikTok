//
//  CommentViewModel.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Foundation
import Combine

@MainActor
class CommentViewModel: ObservableObject {
    @Published var comments = [Comment]()
    @Published var commentText = "" 
    @Published var showEmptyView = false
    @Published var currentUser: User?
    
    private let post: Post
    private let service: CommentService
    
    private var cancellables = Set<AnyCancellable>()
    
    var commentCountText: String {
        return "\(comments.count) comments"
    }
    
    init(post: Post, service: CommentService) {
        self.post = post
        self.service = service
        
        setupSubscribers()
    }
    
    func fetchComments() async {
        do {
            self.comments = try await service.fetchComments()
            showEmptyView = comments.isEmpty
        } catch {
            print("DEBUG: Failed to fetch comments with error: \(error.localizedDescription)")
        }
    }
    
    func uploadComment() async {
        guard !commentText.isEmpty else { return }
        
        do {
            guard let comment = try await service.uploadComment(commentText: commentText) else { return }
            commentText = ""
            comments.insert(comment, at: 0)
            
            if showEmptyView { showEmptyView.toggle() }
        } catch {
            print("DEBUG: Failed to upload comment with error \(error.localizedDescription)")
        }
    }
    
    private func setupSubscribers() {
        service.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
}
