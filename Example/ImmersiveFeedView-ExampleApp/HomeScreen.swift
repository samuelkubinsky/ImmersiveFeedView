//
//  HomeScreen.swift
//  ImmersiveFeedView-ExampleApp
//
//  Created by Samuel Kubinský on 19/06/2024.
//

import SwiftUI
import ImmersiveFeedView

struct HomeScreen: View {
    @State var indexPathPresented = IndexPath(item: 0, section: 0)
    
    @State var snapshot = {
        var snapshot = NSDiffableDataSourceSnapshot<Int, URL>()
        mockedPosts.enumerated().forEach { section, post in
            snapshot.appendSections([section])
            snapshot.appendItems(post.images, toSection: section)
        }
        return snapshot
    }()
    
    var body: some View {
        ImmersiveFeedView(
            indexPathPresented: $indexPathPresented,
            snapshot: snapshot,
            cellContentProvider: { indexPath, url in
                PostImageView(url: url)
            },
            overlayContentProvider: { section in
                PostOverlayView(
                    indexPathPresented: $indexPathPresented,
                    section: section,
                    post: mockedPosts[section]
                )
            },
            isDismissing: { indexPath in
                print("pause: \(indexPath)")
            },
            didPresent: { indexPath in
                print("play: \(indexPath)")
            },
            refreshControlAction: {
                try? await Task.sleep(for: .seconds(2))
            }
        )
        .ignoresSafeArea()
    }
}

#Preview {
    HomeScreen()
}
