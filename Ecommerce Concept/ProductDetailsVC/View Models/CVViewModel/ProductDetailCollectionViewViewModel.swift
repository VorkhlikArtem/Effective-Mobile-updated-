//
//  ProductDetailCollectionViewViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 06.12.2022.
//

import Foundation

protocol DetailCVViewModelProtocol {
  
}

struct DetailCVViewModel: DetailCVViewModelProtocol {

    enum Section: Int, CaseIterable {
        case images
    }

    struct Item: Hashable {
        let imageUrlString: String
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(imageUrlString)
        }
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.imageUrlString == rhs.imageUrlString
        }
        
    }
}



