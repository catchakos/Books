//
//  ToBottomDismissal.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import UIKit

class ToBottomDismissal<R: UIViewController & CustomPresentedViewController>: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? UIViewController & CustomPresentedViewController else { return }

        let duration = transitionDuration(using: transitionContext)
        let containerView = fromViewController.containerViewForCustomPresentation
        let backView = fromViewController.backgroundViewForCustomPresentation

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 20, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            containerView.transform = CGAffineTransform(translationX: 0, y: containerView.frame.height * 1.5)
            backView.alpha = 0
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
