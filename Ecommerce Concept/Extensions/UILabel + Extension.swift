//
//  UILabel + Extension.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import UIKit

extension UILabel {
    convenience init(text: String? = nil, font: UIFont?, textColor: UIColor) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
    }
    
    convenience init(text: String? = nil, font: UIFont?, textColor: UIColor, labelColor: UIColor) {
        self.init(text: text, font: font, textColor: textColor)
        backgroundColor = labelColor
        
    }
}
