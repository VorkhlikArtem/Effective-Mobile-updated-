//
//  FilteringTableView.swift
//  EcommerceConcept
//
//  Created by Артём on 04.12.2022.
//

import Foundation

enum FilterOption: CaseIterable {
    
    case brand(brandNames: [String] )
    case price( [(minPrice: Int, maxPrice: Int)] )
    case size( [(minSize: Float, maxSize: Float)] )
    
    static var allCases: [FilterOption] = [.brand(brandNames: ["IPhone", "Samsung", "Xiaomi", "Motorola"]),
                                            .price([
                                                (minPrice: 100, maxPrice: 200),
                                                (minPrice: 200, maxPrice: 300),
                                                (minPrice: 300, maxPrice: 400),
                                                (minPrice: 400, maxPrice: 500),
                                                (minPrice: 500, maxPrice: 600),
                                                (minPrice: 600, maxPrice: 700),
                                                (minPrice: 700, maxPrice: 800),
                                                (minPrice: 800, maxPrice: 900),
                                                (minPrice: 900, maxPrice: 1000)]),
                                            .size([
                                                (minSize: 3.5, maxSize: 4.5),
                                                (minSize: 4.5, maxSize: 5.5),
                                                (minSize: 5.5, maxSize: 6.5),
                                                (minSize: 6.5, maxSize: 7.5)])
    ]
    
    var title: String {
        switch self {
        case .brand:
            return "Brand"
        case .price:
            return "Price"
        case .size:
            return "Size"
        }
    }
    
    var descriptions: [String] {
        switch self {
        case .brand(let brandNames):
            return brandNames.map { $0 }
        case .price(let minMaxPricesArray):
            return minMaxPricesArray.map { "$\($0.minPrice) - $\($0.maxPrice)" }
        case .size(let minMaxSizesArray):
            return minMaxSizesArray.map { "\($0.minSize) to \($0.maxSize) inches" }
        }
    }
}


