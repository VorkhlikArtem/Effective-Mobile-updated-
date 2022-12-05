//
//  ProductDetailsViewController.swift
//  EcommerceConcept
//
//  Created by Артём on 05.12.2022.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        let star = RatingStackView(rating: 3.7)
        star.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(star)
        
        NSLayoutConstraint.activate([
            star.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            star.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
           
        ])
    }
}

//MARK: - SwiftUI
import SwiftUI
struct ProductDetailsViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().ignoresSafeArea(.all).previewInterfaceOrientation(.portrait)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = UINavigationController(rootViewController: ProductDetailsViewController())
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }

        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
    }
}
