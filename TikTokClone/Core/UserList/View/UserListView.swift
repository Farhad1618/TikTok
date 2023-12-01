//
//  UserListView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel = UserListViewModel(service: UserListService())

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.users) { user in
                    NavigationLink(value: user) {
                        UserCell(user: user)
                            .padding(.horizontal)
                    }
                }
                
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top)
        }
    }
}

#Preview {
    UserListView()
}
