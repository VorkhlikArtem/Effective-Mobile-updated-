//
//  UIView + Constraints.swift
//  EcommerceConcept
//
//  Created by Артём on 09.12.2022.
//

import UIKit

extension UIView {
    func addSubviewWithWholeFilling(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor)

        ])
    }
    
    func addSubviewAtTheBottom(subview: UIView, bottomOffset: CGFloat) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: leadingAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomOffset),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor)

        ])
    }
}

//extension UIView {
//    var viewOfVC: UIView {
//        var superView = self
//        while true {
//            guard let superviewOfSuperview = superView.superview else {break}
//            superView = superviewOfSuperview
//            print(superView)
//        }
//        return superView
//    }
//}



