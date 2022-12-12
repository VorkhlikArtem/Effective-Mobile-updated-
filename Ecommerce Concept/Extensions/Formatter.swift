//
//  Formatter.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String {
        Formatter.withSeparator.string(for: self) ?? ""
        
    }
}

extension Numeric {
    var formattedPriceWithSeparatorAndTwoFractionDigits: String {

        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        formatter.numberStyle = .currencyAccounting
        formatter.groupingSeparator = ","
        return formatter.string(for: self) ?? ""
    }
}




