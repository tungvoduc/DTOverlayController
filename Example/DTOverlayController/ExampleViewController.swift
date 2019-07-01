//
//  ExampleViewController.swift
//  DTOverlayController_Example
//
//  Created by Tung Vo on 17.6.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import DTOverlayController

class ExampleViewController: UITableViewController {
    
    private let cellIdentifier = "Cell"

    enum Selection: CaseIterable {
        case navigation
        case tabbar
        case disabledPanGesture
        
        var title: String {
            switch self {
            case .navigation:
                return "NavigationController"
            case .disabledPanGesture:
                return "Pan Gesture disabled"
            default:
                return "TabbarController"
            }
        }
        
        var viewController: UIViewController {
            switch self {
            case .navigation:
                return UINavigationController(rootViewController: CityListViewController(cellType: .light))
            case .disabledPanGesture:
                return UINavigationController(rootViewController: CityListViewController(cellType: .light))
            case .tabbar:
                let tabbarController = UITabBarController()
                let navigationController1 = UINavigationController(rootViewController: CityListViewController(cellType: .light))
                let navigationController2 = UINavigationController(rootViewController: CityListViewController(cellType: .dark))
                tabbarController.viewControllers = [navigationController1, navigationController2]
                return tabbarController
            }
        }
    }
    
    private var selections = Selection.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Examples"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let selection = selections[indexPath.row]
        cell.textLabel?.text = selection.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selection = selections[indexPath.row]
        let viewController = DTOverlayController(viewController: selection.viewController)
        viewController.dismissableProgress = 0.4
        
        switch selection {
        case .disabledPanGesture:
            if #available(iOS 11.0, *) {
                viewController.overlayHeight = .inset(50 + view.safeAreaInsets.top)
            } else {
                viewController.overlayHeight = .inset(50)
            }
            viewController.isPanGestureEnabled = false
        default:
            break
        }
        
        present(viewController, animated: true, completion: nil)
    }
    
}
