//
//  Comment.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Firebase

struct Comment: Identifiable, Codable {
    let id: String
    let postOwnerUid: String
    let commentText: String
    let postId: String
    let timestamp: Timestamp
    let commentOwnerUid: String
    
    var user: User?
}
