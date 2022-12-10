//
//  UIApplication+.swift
//  EcommerceConcept
//
//  Created by Артём on 10.12.2022.
//

import UIKit

extension UIApplication {
    static var keyWindow: UIWindow? {
        Self.shared.connectedScenes
            .filter{$0.activationState == .foregroundActive}
            .map{$0 as? UIWindowScene}
            .compactMap{$0}
            .first?.windows
            .filter{$0.isKeyWindow}.first
    }
    
}
