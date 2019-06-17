//
//  DTOverlayController.swift
//  DTOverlayController
//
//  Created by Tung Vo on 9.6.2019.
//

import UIKit

open class DTOverlayController: UIViewController, UIViewControllerTransitioningDelegate {
    
    /// Child view controller to be laid over
    open var viewController: UIViewController
    
    /// Top left and top right corner radius of `viewController`'s view.
    /// Default value is 10.
    public var overlayViewCornerRadius: CGFloat = 10 {
        didSet {
            if viewIfLoaded != nil {
                updateCornerRadius()
            }
        }
    }
    
    /// Indicates if pan gesture is enabled on view controller's view
    /// With pan gesture disabled, view controller cannot be dismissed by dragging down view controller.
    /// Default value is `true`.
    public var isPanGestureEnabled: Bool = true {
        didSet {
            if viewIfLoaded != nil {
                if isPanGestureEnabled {
                    interactiveTransition.enablePanGesureOnViewController()
                } else {
                    interactiveTransition.disablePanGesureOnViewController()
                }
            }
        }
    }
    
    /// Height of `viewController`'s view inside DTOverlayController.
    public var overlayHeight: DTLayOverHeight
    
    /// Threshold progress for lay over view controller to be totally dismissed.
    public var dismissableProgress: CGFloat {
        didSet {
            interactiveTransition.dismissableProgress = dismissableProgress
        }
    }
    
    /// Indicates if the top handle should be hidden or not.
    /// Default value is `false`.
    public var isHandleHidden: Bool = false {
        didSet {
            handle.isHidden = isHandleHidden
        }
    }
    
    /// Space on top of `viewController`
    /// Default value is 30.
    public var handleVerticalSpace: CGFloat = 30 {
        didSet {
            viewIfLoaded?.setNeedsLayout()
        }
    }
    
    /// Handle's size
    public var handleSize: CGSize = CGSize(width: 60, height: 6) {
        didSet {
            viewIfLoaded?.setNeedsLayout()
            handle.layer.cornerRadius = handleSize.height / 2
        }
    }
    
    private lazy var handle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var interactiveTransition: InteractiveTransition = InteractiveTransition(viewController: self, dismissableProgress: dismissableProgress)
    
    public init(viewController: UIViewController, overlayHeight: DTLayOverHeight = .static(700), dismissableProgress: CGFloat = 0.4) {
        self.viewController = viewController
        self.overlayHeight = overlayHeight
        self.dismissableProgress = dismissableProgress
        
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
        
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(handle)
        updateCornerRadius()
        viewController.view.layer.masksToBounds = true
        handle.layer.cornerRadius = handleSize.height / 2
        
        if isPanGestureEnabled {
            interactiveTransition.enablePanGesureOnViewController()
        }
        
        interactiveTransition.scrollViewRepresentable = viewController as? DTScrollViewRepresentable
        view.addSubview(viewController.view)
        
        observeScrollViewUpdate(with: viewController)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let size = view.bounds.size
        handle.frame = CGRect(origin: CGPoint(x: (size.width - handleSize.width) / 2, y: (handleVerticalSpace - handleSize.height) / 2), size: handleSize)
        viewController.view.frame = CGRect(origin: CGPoint(x: 0, y: handleVerticalSpace), size: CGSize(width: size.width, height: size.height - handleVerticalSpace))
    }
    
    private func updateCornerRadius() {
        if #available(iOS 11.0, *) {
            viewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            viewController.view.layer.cornerRadius = overlayViewCornerRadius
        } else {
            // Fallback on earlier versions
            addCornerRadiusMask()
        }
    }
    
    private func addCornerRadiusMask() {
        let path = UIBezierPath(roundedRect: viewController.view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: overlayViewCornerRadius, height: overlayViewCornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        viewController.view.layer.mask = mask
    }
    
    /// This method will recursively check rootViewController and its chilren
    /// whether or not they are `UITabbarController` or `UINavigationController`
    /// and then set `delegate`.
    /// Its purpose is to notify when container view controller updates it visible child
    /// view controller, and thus reacts to `rootScrollView` changes.
    /// - SeeAlso: `notifyRootScrollViewDidChange`
    open func observeScrollViewUpdate(with rootViewController: UIViewController) {
        if let navigationController = rootViewController as? UINavigationController {
            if navigationController.delegate != nil {
                
            } else {
                navigationController.delegate = self
            }
        } else if let tabbarController = rootViewController as? UITabBarController {
            if tabbarController.delegate != nil {
                
            } else {
                tabbarController.delegate = self
            }
        }
        
        for child in rootViewController.children {
            observeScrollViewUpdate(with: child)
        }
    }

    // MARK: - UIViewControllerTransitioningDelegate
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitioningAnimator()
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitioningAnimator()
    }
    
    private func transitioningAnimator() -> TransitioningAnimator {
        if interactiveTransition.interactionInProgress {
            return TransitioningAnimator(duration: 1.0)
        }
        return TransitioningAnimator()
    }
    
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DTOverlayPresentationController(presentedViewController: presented, presenting: presenting, overlayHeight: overlayHeight)
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard interactiveTransition.interactionInProgress else {
            return nil
        }
        
        return interactiveTransition
    }
    
    /// Notify interactiveTransition update of the intefering scrollView
    /// You might need to call this method if `viewController` is a container controller and it updates its visible child view controller.
    public func notifyRootScrollViewDidChange() {
        interactiveTransition.updateActiveScrollView()
    }
}

// MARK: - UINavigationControllerDelegate
extension DTOverlayController: UINavigationControllerDelegate {
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        notifyRootScrollViewDidChange()
    }
}

// MARK: - UITabBarControllerDelegate
extension DTOverlayController: UITabBarControllerDelegate {
    open func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        notifyRootScrollViewDidChange()
    }
}

// MARK: - UIViewController
extension UIViewController {
    public var overlayController: DTOverlayController? {
        var parentViewController = parent
        while parentViewController != nil {
            if let overlayController = parentViewController as? DTOverlayController {
                return overlayController
            } else {
                parentViewController = parentViewController?.parent
            }
        }
        
        return nil
    }
}
