//
//  Post.swift
//  ImmersiveFeedView-ExampleApp
//
//  Created by Samuel Kubinský on 19/06/2024.
//

import Foundation

struct Post: Hashable {
    let author: String
    let profilePictureUrl: URL
    let createdAt: String
    let description: String
    let likeCount: Int
    let commentCount: Int
    let images: [URL]
}
