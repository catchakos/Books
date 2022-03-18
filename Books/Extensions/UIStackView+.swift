//
//  UIStackView+.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import UIKit

extension UIStackView {
    static func stack(
        with views: [UIView],
        axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 8
    ) -> UIStackView {
        switch axis {
        case .horizontal:
            return UIStackView.horizontal(
                with: views,
                distribution: distribution,
                alignment: alignment,
                spacing: spacing
            )
        case .vertical:
            return UIStackView.vertical(
                with: views,
                distribution: distribution,
                alignment: alignment,
                spacing: spacing
            )
        @unknown default:
            fatalError("treat case")
        }
    }

    static func horizontal(
        with views: [UIView],
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 8
    ) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = distribution
        stack.alignment = alignment
        stack.spacing = spacing

        views.forEach { stack.addArrangedSubview($0) }

        return stack
    }

    static func vertical(
        with views: [UIView],
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 8
    ) -> UIStackView {
        let stack = horizontal(
            with: views,
            distribution: distribution,
            alignment: alignment,
            spacing: spacing
        )
        stack.axis = .vertical
        return stack
    }

    func cleanup() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
