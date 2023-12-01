//
//  ExploreView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            UserListView()
                .navigationTitle("Explore")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: User.self) { user in
                    ProfileView(user: user)
                }
        }
    }
}

#Preview {
    ExploreView()
}
