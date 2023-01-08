//
//  MainTabBarController.swift
//  EcommerceConcept
//
//  Created by Артём on 09.12.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .blackTextColor
        tabBar.backgroundColor = .white
        setupTabBar()
    }
    
    private func setupTabBar() {
        let mainNC = generateNavigationController(rootViewController: MainViewController(), title: "Main", image: "house")
        
        let cartVC = CartTableViewController()
        cartVC.viewModel = CombineCartViewModel()
        let cartNC = generateNavigationController(rootViewController: cartVC, title: "Cart", image: "cart")
  
        viewControllers = [mainNC, cartNC]
    }
    
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = UIImage(systemName: image)
        return navigationVC
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard let nc = selectedViewController as? UINavigationController,
              let topVC = nc.topViewController,
              topVC.isKind(of: ProductDetailsViewController.self) else {
                  return .all
              }
        
        return .portrait
    }
    
}
