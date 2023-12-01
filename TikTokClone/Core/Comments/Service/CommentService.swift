//
//  CommentService.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Firebase

protocol CommentServiceProtocol {
    func fetchComments() async throws -> [Comment]
}

class MockCommentService: CommentServiceProtocol {
    func fetchComments() async throws -> [Comment] {
        return DeveloperPreview.comments
    }    
}

class CommentService: CommentServiceProtocol {
    private var comments = [Comment]()
    private let post: Post
    private let userService: UserService
    @Published var currentUser: User?
    
    private var commentsCollection: CollectionReference {
        return FirestoreConstants.PostsCollection.document(post.id).collection("post-comments")
    }
    
    init(post: Post, userService: UserService) {
        self.post = post
        self.userService = userService
        
        Task { await fetchCurrentUser() }
    }
    
    func fetchComments() async throws -> [Comment] {
        self.comments = try await commentsCollection
            .order(by: "timestamp", descending: true)
            .getDocuments(as: Comment.self)
        
        await withThrowingTaskGroup(of: Void.self) { group in
            for comment in comments {
                group.addTask { try await self.fetchCommentUserData(comment) }
            }
        }
        
        return comments
    }
    
    func fetchCommentUserData(_ comment: Comment) async throws {
        guard let index = comments.firstIndex(where: { $0.id == comment.id }) else { return }
        comments[index].user = try await userService.fetchUser(withUid: comment.commentOwnerUid)
    }
    
    func uploadComment(commentText: String) async throws -> Comment? {
        let ref = commentsCollection.document()
        guard let currentUid = Auth.auth().currentUser?.uid else { return nil }
        
        var comment = Comment(
            id: ref.documentID,
            postOwnerUid: post.ownerUid,
            commentText: commentText,
            postId: post.id,
            timestamp: Timestamp(), 
            commentOwnerUid: currentUid
        )
        
        guard let commentData = try? Firestore.Encoder().encode(comment) else { return nil }
        
        async let _ = try commentsCollection.document(ref.documentID).setData(commentData)
        async let _ = try FirestoreConstants.PostsCollection.document(post.id).updateData([
            "commentCount": post.commentCount + 1
        ])
        
        NotificationManager.shared.uploadCommentNotification(toUid: post.ownerUid, post: post)
        
        if let currentUser = currentUser {
            comment.user = currentUser
        }
        
        return comment
    }
    
    @MainActor
    func fetchCurrentUser() async {
        self.currentUser = try? await userService.fetchCurrentUser()

    }
}
