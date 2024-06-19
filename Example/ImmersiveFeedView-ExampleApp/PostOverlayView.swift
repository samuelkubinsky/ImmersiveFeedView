//
//  PostOverlayView.swift
//  ImmersiveFeedView-ExampleApp
//
//  Created by Samuel Kubinský on 20/06/2024.
//

import SwiftUI

struct PostOverlayView: View {
    let post: Post
    
    var gradient: some View {
        LinearGradient(
            stops: [
                .init(color: .black.opacity(0.8), location: 0.0),
                .init(color: .black.opacity(0.0), location: 0.2),
                .init(color: .black.opacity(0.0), location: 0.8),
                .init(color: .black.opacity(0.8), location: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
//        .ignoresSafeArea()
    }
    
    var profile: some View {
        Button {
            print("profile")
        } label: {
            HStack {
                AsyncImage(url: post.profilePictureUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                
                Text(verbatim: post.author)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var description: some View {
        Text(post.description)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var pageIndicator: some View {
//        HStack {
//            ForEach(0 ..< post.images.count, id: \.self) { index in
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundStyle(
                        .white.opacity(0.5)
                    )
//            }
//        }
    }
    
    var controls: some View {
        HStack(spacing: 20) {
            Group {
                Button {
                    print("like")
                } label: {
                    Image(systemName: "heart")
                }
                
                Button {
                    print("comment")
                } label: {
                    Image(systemName: "message")
                }
                
                Button {
                    print("share")
                } label: {
                    Image(systemName: "paperplane")
                }
            }
            .imageScale(.large)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 0) {
                Button {
                    print("likes")
                } label: {
                    Text("\(post.likeCount) likes")
                }
                
                Button {
                    print("comments")
                } label: {
                    Text("\(post.commentCount) comments")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var body: some View {
        ZStack {
            gradient
            VStack {
                profile
                
                Spacer()
                
                Group {
                    description
                    
                    Spacer()
                        .frame(height: 20)
                    
                    pageIndicator
                    
                    Spacer()
                        .frame(height: 20)
                    
                    controls
                }
            }
            .padding()
        }
    }
}

#Preview {
    PostOverlayView(post: mockedPosts[0])
}
