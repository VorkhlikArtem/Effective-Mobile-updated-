//
//  UIViewController + Extension.swift
//  EcommerceConcept
//
//  Created by Артём on 11.12.2022.
//

import UIKit

extension UIViewController {
    func setUIOrientation(_ value: UIInterfaceOrientation) {
        UIDevice.current.setValue(value.rawValue, forKey: "orientation")
    }
}
