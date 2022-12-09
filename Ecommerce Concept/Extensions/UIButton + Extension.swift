//
//  UIButton + Extension.swift
//  EcommerceConcept
//
//  Created by Артём on 09.12.2022.
//

import UIKit

extension UIButton {
    convenience init(text: String, font: UIFont?, textColor: UIColor, buttonColor: UIColor? = nil) {
        self.init(type: .system)
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = buttonColor
    }
    
    convenience init(image: String, imageColor: UIColor, buttonColor: UIColor? = nil) {
        self.init(type: .system)
        self.setImage(UIImage(named: image), for: .normal)
        self.tintColor = imageColor
        self.backgroundColor = buttonColor
    }
}
