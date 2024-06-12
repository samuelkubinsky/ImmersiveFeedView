//
//  ImmersiveFeedView.swift
//
//
//  Created by Samuel Kubinský on 12/06/2024.
//

import SwiftUI

public struct ImmersiveFeedView<SectionType: Hashable & Sendable, ItemType: Hashable & Sendable, Content: View>: UIViewRepresentable {
    
    public typealias UIViewType = ImmersiveFeedCollectionView<SectionType, ItemType, Content>
    
    @Binding var indexPathPresented: IndexPath
    
    let snapshot: NSDiffableDataSourceSnapshot<SectionType, ItemType>
    let cellContentProvider: (IndexPath, ItemType) -> Content
    
    var isDismissing: ((IndexPath) -> Void)?
    var didPresent: ((IndexPath) -> Void)?
    
    var refreshControlColor: Color?
    var refreshControlAction: (() async -> Void)?
    
    public func makeUIView(context: Context) -> ImmersiveFeedCollectionView<SectionType, ItemType, Content> {
        let collectionView = ImmersiveFeedCollectionView<SectionType, ItemType, Content>(cellContentProvider: cellContentProvider)
        collectionView.delegate = context.coordinator
        collectionView.diffableDataSource.apply(snapshot, animatingDifferences: false)
        collectionView.setupRefreshControl(color: refreshControlColor, action: refreshControlAction)
        return collectionView
    }
    
    public func updateUIView(_ collectionView: ImmersiveFeedCollectionView<SectionType, ItemType, Content>, context: Context) {
        collectionView.diffableDataSource.apply(snapshot, animatingDifferences: false)
        
        if !collectionView.indexPathsForVisibleItems.contains(indexPathPresented) {
            collectionView.scrollToItem(at: indexPathPresented, at: [], animated: true)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        .init(self)
    }
    
    // MARK: - Coordinator
    
    public final class Coordinator: NSObject, UICollectionViewDelegate {
        
        private let parent: ImmersiveFeedView
        private var visibleIndexPaths = [IndexPath]()
        
        init(_ parent: ImmersiveFeedView) {
            self.parent = parent
        }
        
        public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            // prevent "dismissing" the first cell
            let wasEmpty = visibleIndexPaths.isEmpty
            
            visibleIndexPaths.append(indexPath)
            
            if !wasEmpty, let indexPath = visibleIndexPaths.first {
                parent.isDismissing?(indexPath)
            }
        }
        
        public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if let index = visibleIndexPaths.firstIndex(of: indexPath) {
                visibleIndexPaths.remove(at: index)
            }
            
            if let indexPath = visibleIndexPaths.first {
                parent.indexPathPresented = indexPath
                parent.didPresent?(indexPath)
            }
        }
        
    }
    
}
