//
//  ImmersiveFeedCollectionView.swift
//
//
//  Created by Samuel Kubinský on 12/06/2024.
//

import SwiftUI

public final class ImmersiveFeedCollectionView<
    SectionType: Hashable & Sendable,
    ItemType: Hashable & Sendable,
    CellContent: View,
    OverlayContent: View
>: UICollectionView {
    
    private let cellContentProvider: (IndexPath, ItemType) -> CellContent
    private let overlayContentProvider: (Int) -> OverlayContent
    
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<SectionType, ItemType> = {
        let cell = ImmersiveFeedCell.register(content: cellContentProvider)
        let overlay = ImmersiveFeedSectionOverlay.register(content: overlayContentProvider)
        let dataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>(collectionView: self) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: item)
        }
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: overlay, for: indexPath)
        }
        return dataSource
    }()
    
    init(cellContentProvider: @escaping (IndexPath, ItemType) -> CellContent, overlayContentProvider: @escaping (Int) -> OverlayContent) {
        self.cellContentProvider = cellContentProvider
        self.overlayContentProvider = overlayContentProvider
        
        let layout = {
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            section.boundarySupplementaryItems = [
                .init(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)),
                    elementKind: "ImmersiveFeedSectionOverlay",
                    containerAnchor: .init(edges: .all)
                )
            ]
            return UICollectionViewCompositionalLayout(section: section)
        }()
        
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .clear
        contentInsetAdjustmentBehavior = .never
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delaysContentTouches = false
        scrollsToTop = false
        allowsSelection = false
        isPagingEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        adjustRefreshControlFrame()
    }
    
    public override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        // UI glitch fix
        isPagingEnabled = false
        super.scrollToItem(at: indexPath, at: [], animated: animated)
        isPagingEnabled = true
    }
    
    private func adjustRefreshControlFrame() {
        let safeAreaInset = safeAreaInsets.top
        guard let refreshControl, safeAreaInset > 0 else { return }
        let offset = contentOffset.y
        refreshControl.frame = CGRect(
            x: refreshControl.frame.minX,
            y: offset + safeAreaInset,
            width: refreshControl.frame.width,
            height: refreshControl.frame.height
        )
    }
    
    func setupRefreshControl(color: Color?, action: (() async -> Void)?) {
        guard let action else {
            refreshControl = nil
            return
        }
        
        let control = UIRefreshControl()
        
        if let color {
            control.tintColor = UIColor(color)
        }
        
        control.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                Task {
                    self.disableUserTouch()
                    await action()
                    self.enableUserTouch()
                }
            },
            for: .valueChanged
        )
        
        refreshControl = control
    }
    
    private func disableUserTouch() {
        // because isScrollEnabled does not cover horizontal scroll
        isUserInteractionEnabled = false
        // disable paging so collectionView can rest scrolled up
        isPagingEnabled = false
        // "let go" of user touch
        let offset = refreshControl?.frame.height ?? 0
        setContentOffset(.init(x: 0, y: -offset), animated: true)
        isScrollEnabled = false
    }
    
    private func enableUserTouch() {
        refreshControl?.endRefreshing()
        isScrollEnabled = true
        isPagingEnabled = true
        isUserInteractionEnabled = true
    }
    
}
