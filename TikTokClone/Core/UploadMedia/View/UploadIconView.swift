//
//  UploadIconView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct UploadIconView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.teal)
                .offset(x: -4)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(.pink)
                .offset(x: 4)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(selectedTab == 0 ? .white : .black)
            
            
            Image(systemName: "plus")
                .fontWeight(.bold)
                .foregroundStyle(selectedTab == 0 ? .black : .white)
        }
        .frame(width: 44, height: 24)
    }
}

#Preview {
    UploadIconView(selectedTab: .constant(1))
}
