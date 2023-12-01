//
//  NotificationCellViewModel.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Foundation

@MainActor
class NotificationCellViewModel: ObservableObject {
    @Published var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    func follow() {
        Task {
            notification.user?.isFollowed = true
        }
    }
    
    func unfollow() {
        Task {
            notification.user?.isFollowed = false
        }
    }
}
