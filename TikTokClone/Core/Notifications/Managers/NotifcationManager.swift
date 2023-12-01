//
//  NotifcationManager.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/11/23.
//

import Foundation

class NotificationManager {
    
    static let shared = NotificationManager()
    private let service = NotificationService()
    
    func uploadLikeNotification(toUid uid: String, post: Post) {
        service.uploadNotification(toUid: uid, type: .like, post: post)
    }
    
    func uploadCommentNotification(toUid uid: String, post: Post) {
        service.uploadNotification(toUid: uid, type: .comment, post: post)
    }
    
    func uploadFollowNotification(toUid uid: String) {
        service.uploadNotification(toUid: uid, type: .follow)
    }
    
    func deleteNotification(toUid uid: String, type: NotificationType) async {
        try? await service.deleteNotification(toUid: uid, type: type)
    }
}
