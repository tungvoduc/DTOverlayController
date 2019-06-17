//
//  InteractiveTransition.swift
//  DTOverlayController_Example
//
//  Created by Tung Vo on 9.6.2019.
//

import UIKit

class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var dismissableProgress: CGFloat
    
    weak var scrollViewRepresentable: DTScrollViewRepresentable? {
        didSet {
            updateActiveScrollView()
        }
    }
    
    var interactionInProgress = false
    
    private var shouldCompleteTransition = false
    
    private weak var viewController: UIViewController!
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    init(viewController: UIViewController, dismissableProgress: CGFloat) {
        self.dismissableProgress = dismissableProgress
        
        super.init()
        self.viewController = viewController
    }
    
    func enablePanGesureOnViewController() {
        viewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func disablePanGesureOnViewController() {
        viewController.view.removeGestureRecognizer(panGestureRecognizer)
    }
    
    func updateActiveScrollView() {
        scrollViewRepresentable?.rootScrollView?.panGestureRecognizer.require(toFail: panGestureRecognizer)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = translation.y / gestureRecognizer.view!.frame.height
        progress = CGFloat(min(max(progress, 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = progress > (1 - dismissableProgress)
            print(progress)
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension InteractiveTransition: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scrollView = scrollViewRepresentable?.rootScrollView, let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        
        let topContentOffset: CGFloat
        
        if #available(iOS 11.0, *) {
            topContentOffset = -scrollView.adjustedContentInset.top
        } else {
            topContentOffset = 0
        }
        
        if scrollView.contentOffset.y == topContentOffset {
            return gestureRecognizer.velocity(in: gestureRecognizer.view!).y > 0
        }
        
        return scrollView.contentOffset.y < topContentOffset
    }
    
}
