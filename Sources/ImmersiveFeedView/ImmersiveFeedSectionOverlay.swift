//
//  ImmersiveFeedSectionOverlay.swift
//  
//
//  Created by Samuel Kubinský on 19/06/2024.
//

import SwiftUI

public final class ImmersiveFeedSectionOverlay<Content: View>: UICollectionReusableView {
    
    static func register(
        content: @escaping (Int) -> Content
    ) -> UICollectionView.SupplementaryRegistration<ImmersiveFeedSectionOverlay> {
        .init(elementKind: "ImmersiveFeedSectionOverlay") { overlayView, elementKind, indexPath in
            overlayView.hostingController = .init(rootView: content(indexPath.section))
            overlayView.constrainViews()
        }
    }
    
    var hostingController: UIHostingController<Content>?
    
    func constrainViews() {
        guard let view = hostingController?.view else { return }
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
//            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hostingController {
            for subview in hostingController.view.subviews {
                let convertedPoint = subview.convert(point, from: self)
                
                if subview.bounds.contains(convertedPoint) {
                    return subview
                }
            }
        }
        return nil
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
    
}
