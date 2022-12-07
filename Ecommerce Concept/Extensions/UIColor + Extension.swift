//
//  UIColor + Extension.swift
//  Ecommerce Concept
//
//  Created by Артём on 03.12.2022.
//

import UIKit

extension UIColor {
    
    static let backgroundColor = #colorLiteral(red: 0.9724746346, green: 0.9725908637, blue: 0.9724350572, alpha: 1)
    static let blackTextColor = UIColor(red: 0.004, green: 0, blue: 0.208, alpha: 1)
    static let grayTextColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    static let darkgrayTextColor = UIColor(red: 0.554, green: 0.554, blue: 0.554, alpha: 1)
    static let orangeColor = #colorLiteral(red: 0.9278513789, green: 0.418097496, blue: 0.2964054346, alpha: 1)
}

extension UIColor {
    convenience init?(hex: String) {
        self.init()
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        let length = hexSanitized.count

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}


