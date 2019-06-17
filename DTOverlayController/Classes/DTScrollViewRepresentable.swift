//
//  DTScrollViewRepresentable.swift
//  DTOverlayController
//
//  Created by Tung Vo on 16.6.2019.
//

import Foundation

/**
Define the root scroll view that can intefere with DTOverlayController's pan gesture.
This protocol is usually conformed by child view controller of DTOverlayController.
In case the child view controller is a container controller (but neither UITabbarController nor UINavigationController), you might need to call `notifyRootScrollViewDidChange` when updating its childcontrollers' appearance.
 
- SeeAlso: `notifyRootScrollViewDidChange`
 */
@objc public protocol DTScrollViewRepresentable: NSObjectProtocol {
    var rootScrollView: UIScrollView? { get }
}

// MARK: - UINavigationController
extension UINavigationController: DTScrollViewRepresentable {
    @objc open var rootScrollView: UIScrollView? {
        guard let scrollViewRepresentable = topViewController as? DTScrollViewRepresentable else {
            return nil
        }
        
        return scrollViewRepresentable.rootScrollView
    }
}

// MARK: - UITabBarController
extension UITabBarController: DTScrollViewRepresentable {
    @objc open var rootScrollView: UIScrollView? {
        guard let scrollViewRepresentable = viewControllers?[selectedIndex] as? DTScrollViewRepresentable else {
            return nil
        }
        
        return scrollViewRepresentable.rootScrollView
    }
}

// MARK: - UITableViewController
extension UITableViewController: DTScrollViewRepresentable {
    @objc open var rootScrollView: UIScrollView? {
        return tableView
    }
}

// MARK: - UICollectionViewController
extension UICollectionViewController: DTScrollViewRepresentable {
    @objc open var rootScrollView: UIScrollView? {
        return collectionView
    }
}
