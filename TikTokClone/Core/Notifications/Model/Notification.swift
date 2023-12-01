//
//  Notification.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Firebase

struct Notification: Identifiable, Codable {
    let id: String
    var postId: String?
    let timestamp: Timestamp
    let type: NotificationType
    let uid: String
    
    var post: Post?
    var user: User?
}

enum NotificationType: Int, Codable {
    case like
    case comment
    case follow
    
    var notificationMessage: String {
        switch self {
        case .like: return " liked one of your posts."
        case .comment: return " commented on one of your posts."
        case .follow: return " started following you."
        }
    }
}
