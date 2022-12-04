//
//  Constants.swift
//  Ecommerce Concept
//
//  Created by Артём on 03.12.2022.
//

import UIKit

struct Constants {
    
    struct CategorySection {
        let title: String
        let imageName: String
    }
    
    static let categorySectionModel: [CategorySection] = [
        CategorySection(title: "Phones", imageName: "phones"),
        CategorySection(title: "Computer", imageName: "computer"),
        CategorySection(title: "Health", imageName: "heart"),
        CategorySection(title: "Books", imageName: "books")
    ]
    
    static let selectCategoryCellWidth: CGFloat = 71
    static let bestSellersGroupAspectRatio: CGFloat = 227 / 376
    
}
