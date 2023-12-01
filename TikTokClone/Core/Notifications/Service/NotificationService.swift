//
//  NotificationService.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Firebase

class NotificationService {
    
    private var notifications = [Notification]()
    private let userService = UserService()
    private let postService = PostService()
    
    func fetchNotifications() async throws -> [Notification] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }

        self.notifications = try await FirestoreConstants.UserNotificationCollection(uid: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments(as: Notification.self)
        
        await withThrowingTaskGroup(of: Void.self) { group in
            for notification in notifications {
                group.addTask { try await self.updateNotification(notification) }
            }
        }
        
        return notifications
    }
    
    func uploadNotification(toUid uid: String, type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        let ref = FirestoreConstants.UserNotificationCollection(uid: uid).document()
        
        let notification = Notification(id: ref.documentID, postId: post?.id, timestamp: Timestamp(), type: type, uid: currentUid)
        guard let data = try? Firestore.Encoder().encode(notification) else { return }
        
        ref.setData(data)
    }
    
    func deleteNotification(toUid uid: String, type: NotificationType, postId: String? = nil) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
        let snapshot = try await FirestoreConstants
            .UserNotificationCollection(uid: uid)
            .whereField("uid", isEqualTo: currentUid)
            .getDocuments()
        
        for document in snapshot.documents {
            guard let notification = try? document.data(as: Notification.self) else { continue }
            guard notification.type == type else { return }
            
            if postId != nil {
                guard postId == notification.postId else { return }
            }
            
            try await document.reference.delete()
        }
    }
    
    private func updateNotification(_ notification: Notification) async throws {
        guard let indexOfNotification = notifications.firstIndex(where: { $0.id == notification.id }) else { return }
        
        async let notificationUser = try userService.fetchUser(withUid: notification.uid)
        self.notifications[indexOfNotification].user = try await notificationUser

        if notification.type == .follow {
            async let isFollowed = userService.checkIfUserIsFollowed(uid: notification.uid)
            self.notifications[indexOfNotification].user?.isFollowed = await isFollowed
        }

        if let postId = notification.postId {
            self.notifications[indexOfNotification].post = try? await postService.fetchPost(postId: postId)
        }
    }
}
