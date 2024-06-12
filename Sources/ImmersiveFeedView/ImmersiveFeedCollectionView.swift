//
//  ImmersiveFeedCollectionView.swift
//
//
//  Created by Samuel Kubinský on 12/06/2024.
//

import SwiftUI

public final class ImmersiveFeedCollectionView<SectionType: Hashable & Sendable, ItemType: Hashable & Sendable, Content: View>: UICollectionView {
    
    private let cellContentProvider: (IndexPath, ItemType) -> Content
    
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<SectionType, ItemType> = {
        let cell = ImmersiveFeedCollectionViewCell.register(content: cellContentProvider)
        return .init(collectionView: self) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: item)
        }
    }()
    
    init(cellContentProvider: @escaping (IndexPath, ItemType) -> Content) {
        self.cellContentProvider = cellContentProvider
        let layout = {
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
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
        guard let refreshControl else { return }
        let offset = contentOffset.y
        let safeAreaInset = safeAreaInsets.top
        refreshControl.frame = CGRect(
            x: refreshControl.frame.minX,
            y: offset + safeAreaInset,
            width: refreshControl.bounds.width,
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
        setContentOffset(.init(x: 0, y: -safeAreaInsets.top), animated: true)
        isScrollEnabled = false
    }
    
    private func enableUserTouch() {
        refreshControl?.endRefreshing()
        isScrollEnabled = true
        isPagingEnabled = true
        isUserInteractionEnabled = true
    }
    
}
