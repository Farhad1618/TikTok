//
//  UserService.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import FirebaseAuth

enum UserError: Error {
    case unauthenticated
}

class UserService {
    func fetchCurrentUser() async throws -> User {
        guard let uid = Auth.auth().currentUser?.uid else { throw UserError.unauthenticated }
        return try await FirestoreConstants.UserCollection.document(uid).getDocument(as: User.self)
    }
    
    func fetchUser(withUid uid: String) async throws -> User {
        return try await FirestoreConstants.UserCollection.document(uid).getDocument(as: User.self)
    }
}

// MARK: - Following

extension UserService {
    func follow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try FirestoreConstants
            .UserFollowingCollection(uid: currentUid)
            .document(uid)
            .setData([:])
        
        async let _ = try FirestoreConstants
            .UserFollowerCollection(uid: uid)
            .document(currentUid)
            .setData([:])
    }
    
    func unfollow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        async let _ = try FirestoreConstants
            .UserFollowingCollection(uid: currentUid)
            .document(uid)
            .delete()

        async let _ = try FirestoreConstants
            .UserFollowerCollection(uid: uid)
            .document(currentUid)
            .delete()
    }
    
    func checkIfUserIsFollowed(uid: String) async -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        
        guard let snapshot = try? await FirestoreConstants
            .UserFollowingCollection(uid: currentUid)
            .document(uid)
            .getDocument() else { return false }
        
        return snapshot.exists
    }
}

// MARK: - User Stats

extension UserService {
    func fetchUserStats(uid: String) async throws -> UserStats {
        async let following = FirestoreConstants
            .FollowingCollection
            .document(uid)
            .collection("user-following")
            .getDocuments()
            .count
        
        async let followers = FirestoreConstants
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .getDocuments()
            .count
        
        async let likes = FirestoreConstants
            .PostsCollection
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments(as: Post.self)
            .map({ $0.likes })
            .reduce(0, +)
        
        return try await .init(following: following, followers: followers, likes: likes)
    }
}
