//
//  TransitioningAnimator.swift
//  DTOverlayController_Example
//
//  Created by Tung Vo on 9.6.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class TransitioningAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: TimeInterval
    
    init(duration: TimeInterval = 0.3) {
        self.duration = duration
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        let view: UIView
        
        let isPresenting = transitionContext.isPresenting
        var finalFrame: CGRect = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .from)!)
        
        if isPresenting {
            view = transitionContext.view(forKey: .to)!
            view.frame = finalFrame
            view.frame.origin.y = containerView.frame.height
            
            containerView.addSubview(view)
        } else {
            view = transitionContext.view(forKey: .from)!
            finalFrame.origin.y = containerView.frame.height
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            view.frame = finalFrame
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}

extension UIViewControllerContextTransitioning {
    var isPresenting: Bool {
        let toViewController = viewController(forKey: .to)
        let fromViewController = viewController(forKey: .from)
        return toViewController?.presentingViewController === fromViewController
    }
}
