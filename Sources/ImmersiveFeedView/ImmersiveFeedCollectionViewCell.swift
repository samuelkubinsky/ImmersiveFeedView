//
//  ImmersiveFeedCollectionViewCell.swift
//
//
//  Created by Samuel Kubinský on 12/06/2024.
//

import SwiftUI

public final class ImmersiveFeedCollectionViewCell: UICollectionViewCell {
    
    static func register<Content: View, ItemType: Hashable & Sendable>(
        content: @escaping (IndexPath, ItemType) -> Content
    ) -> UICollectionView.CellRegistration<ImmersiveFeedCollectionViewCell, ItemType> {
        .init { cell, indexPath, item in
            cell.backgroundConfiguration = .clear()
            cell.contentConfiguration = UIHostingConfiguration {
                content(indexPath, item)
            }
            .margins(.all, 0)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        backgroundConfiguration = nil
        contentConfiguration = nil
    }
    
}
