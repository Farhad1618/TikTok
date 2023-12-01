//
//  ProfileViewModel.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import AVFoundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var user: User
    
    private let userService: UserService
    private let postService: PostService
    private var didCompleteFollowCheck = false
    private var didCompleteStatsFetch = false
    
    init(user: User, userService: UserService, postService: PostService) {
        self.user = user
        self.userService = userService
        self.postService = postService
    }
}

// MARK: - Following

extension ProfileViewModel {
    func follow() {
        Task {
            try await userService.follow(uid: user.id)
            user.isFollowed = true
            user.stats.followers += 1

            NotificationManager.shared.uploadFollowNotification(toUid: user.id)
        }
    }
    
    func unfollow() {
        Task {
            try await userService.unfollow(uid: user.id)
            user.isFollowed = false
            user.stats.followers -= 1
        }
    }
    
    func checkIfUserIsFollowed() async {
        guard !user.isCurrentUser, !didCompleteFollowCheck else { return }
        self.user.isFollowed = await userService.checkIfUserIsFollowed(uid: user.id)
        self.didCompleteFollowCheck = true
    }
}

// MARK: - Stats

extension ProfileViewModel {
    func fetchUserStats() async {
        guard !didCompleteStatsFetch else { return }
        
        do {
            user.stats = try await userService.fetchUserStats(uid: user.id)
            didCompleteStatsFetch = true
        } catch {
            print("DEBUG: Failed to fetch user stats with error \(error.localizedDescription)")
        }
    }
}

// MARK: - Posts

extension ProfileViewModel {
    func fetchUserPosts() async {
        do {
            self.posts = try await postService.fetchUserPosts(user: user)
        } catch {
            print("DEBUG: Failed to fetch posts with error: \(error.localizedDescription)")
        }
    }
}

