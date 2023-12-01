//
//  CommentInputView.swift
//  TikTokClone
//
//  Created by Farhad on 10/9/23.
//

import SwiftUI

import SwiftUI

struct CommentInputView: View {
    @ObservedObject var viewModel: CommentViewModel
    @FocusState private var fieldIsActive: Bool
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("Add a comment", text: $viewModel.commentText, axis: .vertical)
                .padding(10)
                .padding(.leading, 4)
                .padding(.trailing, 48)
                .background(Color(.systemGroupedBackground))
                .clipShape(Capsule())
                .font(.footnote)
                .focused($fieldIsActive)
                .overlay {
                    Capsule()
                        .stroke(Color(.systemGray5), lineWidth: 0)
                }
            
            Button {
                Task {
                    await viewModel.uploadComment()
                    fieldIsActive = false
                }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.pink)
            }
            .padding(.horizontal)
        }
        .tint(.black)
    }
}
