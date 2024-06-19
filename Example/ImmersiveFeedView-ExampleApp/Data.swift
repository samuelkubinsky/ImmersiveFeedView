//
//  Data.swift
//  ImmersiveFeedView-ExampleApp
//
//  Created by Samuel Kubinský on 19/06/2024.
//

import Foundation

let mockedPosts = [
    Post(
        author: "bookwormlib",
        profilePictureUrl: .randomImage,
        createdAt: "3h",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        likeCount: 4482,
        commentCount: 73,
        images: .randomImages(count: 1)
    ),
    Post(
        author: "wordwizard123",
        profilePictureUrl: .randomImage,
        createdAt: "7h",
        description: "Etiam varius lacinia augue ac interdum.",
        likeCount: 174,
        commentCount: 66,
        images: .randomImages(count: 2)
    ),
    Post(
        author: "pixelplayer",
        profilePictureUrl: .randomImage,
        createdAt: "12h",
        description: "Curabitur in ultricies erat. Sed consequat ut orci vitae viverra.",
        likeCount: 991,
        commentCount: 25,
        images: .randomImages(count: 3)
    )
]

extension URL {
    static var randomImage: URL {
        let width = Int.random(in: 500 ... 1000)
        let height = Int.random(in: 500 ... 1000)
        return URL(string: "https://picsum.photos/\(width)/\(height)")!
    }
}

extension Array where Element == URL {
    static func randomImages(count: Int) -> [URL] {
        (0 ..< count).map { _ in URL.randomImage }
    }
}
