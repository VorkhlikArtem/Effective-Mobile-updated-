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
       //let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        
        let mainNC = generateNavigationController(rootViewController: MainViewController(), title: "Main", image: "house")
        
        let cartVC = CartTableViewController()
        cartVC.viewModel = CartTableViewModel()
        let cartNC = generateNavigationController(rootViewController: cartVC, title: "Cart", image: "cart")
  
        
        viewControllers = [mainNC, cartNC]
        //tabBar.items?[1].badgeValue = "sds"
        
       
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = UIImage(systemName: image)
        return navigationVC
    }
    
}
