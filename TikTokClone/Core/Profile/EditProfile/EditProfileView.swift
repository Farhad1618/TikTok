//
//  EditProfileView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/10/23.
//

import SwiftUI
import PhotosUI

enum EditProfileOptions: Hashable {
    case fullname
    case username
    case bio
    
    var navigationTitle: String {
        switch self {
        case .fullname: return "Name"
        case .username: return "Username"
        case .bio: return "Bio"
        }
    }
}

struct EditProfileView: View {
    @StateObject var viewModel = EditProfileViewModel()
    @State private var profileImage: Image?
    @State private var uiImage: UIImage?
    @State private var selectedPickerItem: PhotosPickerItem?
    @Environment(\.dismiss) var dismiss
    @Binding var user: User
    
    init(user: Binding<User>) {
        self._user = user
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                PhotosPicker(selection: $selectedPickerItem, matching: .images) {
                    VStack(spacing: 4) {
                        if let image = profileImage {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: ProfileImageSize.xLarge.dimension, height: ProfileImageSize.xLarge.dimension)
                                .clipShape(Circle())
                                .foregroundColor(Color(.systemGray4))
                        } else {
                            CircularProfileImageView(user: user, size: .xLarge)
                        }
                        
                        Text("Change photo")
                            .font(.subheadline)
                    }
                    .padding()
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    Text("About you")
                        .font(.footnote)
                        .foregroundStyle(Color(.systemGray2))
                        .fontWeight(.semibold)
                    
                    NavigationLink(value: EditProfileOptions.fullname) {
                        HStack {
                            Text("Name")
                            
                            Spacer()
                            
                            Text(user.fullname)
                        }
                    }
                    
                    NavigationLink(value: EditProfileOptions.username) {
                        HStack {
                            Text("Username")
                            
                            Spacer()
                            
                            Text(user.username)
                        }
                    }
                    
                    NavigationLink(value: EditProfileOptions.bio) {
                        HStack {
                            Text("Bio")
                            
                            Spacer()
                            
                            Text(user.bio ?? "Add a bio")
                        }
                    }
                    
                    Spacer()
                }
                .font(.subheadline)
                .padding()
            }
            .navigationTitle("Edit profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        updateProfileImage()
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                }
            }
            .navigationDestination(for: EditProfileOptions.self, destination: { option in
                Text(option.navigationTitle)
            })
            .onChange(of: selectedPickerItem) { oldValue, newValue in
                Task { await loadImage(fromItem: newValue) }
            }
        }
    }
}

extension EditProfileView {
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func updateProfileImage() {
        Task {
            guard let uiImage = uiImage else { return }
            let imageUrl = await viewModel.uploadProfileImage(uiImage)
            user.profileImageUrl = imageUrl
            dismiss()
        }
    }
}

#Preview {
    EditProfileView(user: .constant(DeveloperPreview.user))
}
