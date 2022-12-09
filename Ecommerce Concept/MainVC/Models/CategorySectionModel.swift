//
//  CategorySectionModel.swift
//  EcommerceConcept
//
//  Created by Артём on 10.12.2022.
//

import Foundation

struct CategoryItem {
    let title: String
    let imageName: String
}

extension CategoryItem {
    static let categorySectionModel: [CategoryItem] = [
        CategoryItem(title: "Phones", imageName: "phones"),
        CategoryItem(title: "Computer", imageName: "computer"),
        CategoryItem(title: "Health", imageName: "heart"),
        CategoryItem(title: "Books", imageName: "books")
    ]
}


