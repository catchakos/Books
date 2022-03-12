//
//  BottomUpPresentation.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import UIKit

class BottomUpPresentation<R: UIViewController & CustomPresentedViewController>: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) as? CustomPresentedViewController & UIViewController else { return }
        
        let contentView = toViewController.containerViewForCustomPresentation
        let backView = toViewController.backgroundViewForCustomPresentation
        
        contentView.transform = CGAffineTransform(translationX: 0, y: 250)
        contentView.alpha = 0

        backView.alpha = 0
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        toViewController.view.isHidden = false
        
        let duration = transitionDuration(using: transitionContext)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 6,
            initialSpringVelocity: 9,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: {
                contentView.transform = CGAffineTransform(translationX: 0, y: 0)
                contentView.alpha = 1
                backView.alpha = 1
            }
        ) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
