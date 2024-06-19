//
//  ImmersiveFeedCell.swift
//
//
//  Created by Samuel Kubinský on 12/06/2024.
//

import SwiftUI

public final class ImmersiveFeedCell: UICollectionViewCell {
    
    static func register<Content: View, ItemType: Hashable & Sendable>(
        content: @escaping (IndexPath, ItemType) -> Content
    ) -> UICollectionView.CellRegistration<ImmersiveFeedCell, ItemType> {
        .init { cell, indexPath, item in
            cell.clipsToBounds = true
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
