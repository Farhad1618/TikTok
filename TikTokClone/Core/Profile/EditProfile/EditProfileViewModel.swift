//
//  EditProfileViewModel.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/10/23.
//

import SwiftUI
import Firebase

class EditProfileViewModel: ObservableObject {
    
    func uploadProfileImage(_ uiImage: UIImage) async -> String? {
        do {
            async let imageUrl = ImageUploader.uploadImage(image: uiImage, type: .profile)
            try await updateUserProfileImage(withImageUrl: try await imageUrl)
            return try await imageUrl
        } catch {
            print("DEBUG: Failed to update image with error: \(error.localizedDescription)")
            return nil 
        }
    }
    
    func updateUserProfileImage(withImageUrl imageUrl: String?) async throws {
        guard let imageUrl = imageUrl else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await FirestoreConstants.UserCollection.document(currentUid).updateData([
            "profileImageUrl": imageUrl
        ])
    }
}
