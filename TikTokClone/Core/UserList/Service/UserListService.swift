//
//  UserListService.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Firebase

class UserListService {
    func fetchUsers() async throws -> [User] {
        return try await FirestoreConstants.UserCollection.getDocuments(as: User.self)
    }
}
