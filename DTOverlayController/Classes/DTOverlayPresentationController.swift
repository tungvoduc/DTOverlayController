//
//  DTLayOverPresentationController.swift
//  DTOverlayController
//
//  Created by Tung Vo on 9.6.2019.
//

import UIKit

/// Represent height inside DTOverlayController
///
/// - `static`: <#`static` description#>
/// - dynamic: <#dynamic description#>
public enum DTLayOverHeight {
    case `static`(CGFloat)
    case dynamic(CGFloat)
}

///
open class DTOverlayPresentationController: UIPresentationController {
    
    var layOverHeight: DTLayOverHeight

    public lazy var dimminView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black
        return view
    }()
    
    public var bar: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        return view
    }()
    
    init(presentedViewController: UIViewController, presenting: UIViewController?, layOverHeight: DTLayOverHeight) {
        self.layOverHeight = layOverHeight
        
        super.init(presentedViewController: presentedViewController, presenting: presenting)
        addTapGestureToDimmingView()
    }
    
    override open func presentationTransitionWillBegin() {
        containerView?.addSubview(dimminView)
        containerView?.addSubview(presentedViewController.view)
        
        let transitionCoordinator = presentingViewController.transitionCoordinator
        
        dimminView.alpha = 0
        transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimminView.alpha = 0.85
        }, completion: nil)
    }
    
    override open func dismissalTransitionWillBegin() {
        let transitionCoordinator = presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimminView.alpha = 0.0
        }, completion: nil)
    }
    
    override open func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimminView.removeFromSuperview()
        }
    }
    
    override open func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return presentedViewSize(withContainerSize: parentSize)
    }
    
    override open func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        let bounds = containerView!.bounds
        dimminView.frame = bounds
        
        let presentedSize = presentedViewSize(withContainerSize: containerView!.bounds.size)
        presentedViewController.view.frame = CGRect(origin: CGPoint(x: 0, y: bounds.height - presentedSize.height), size: presentedSize)
    }
    
    private func presentedViewSize(withContainerSize parentSize: CGSize) -> CGSize {
        let height: CGFloat
        
        switch layOverHeight {
        case let .dynamic(ratio):
            height = ratio * parentSize.height
        case let .static(fixedHeight):
            height = fixedHeight
        }
        
        return CGSize(width: parentSize.width, height: height)
    }
    
    private func addTapGestureToDimmingView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        dimminView.addGestureRecognizer(tapGesture)
        dimminView.isUserInteractionEnabled = true
    }
    
    @objc private func didTap(_ gestureRecognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}
