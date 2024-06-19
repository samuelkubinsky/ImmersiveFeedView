//
//  PostImageView.swift
//  ImmersiveFeedView-ExampleApp
//
//  Created by Samuel Kubinský on 20/06/2024.
//

import SwiftUI

struct PostImageView: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

#Preview {
    PostImageView(url: URL(string: "https://picsum.photos/400/600"))
}
