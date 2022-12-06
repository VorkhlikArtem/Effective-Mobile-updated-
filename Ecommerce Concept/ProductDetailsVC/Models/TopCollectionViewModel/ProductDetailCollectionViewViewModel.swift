//
//  ProductDetailCollectionViewViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 06.12.2022.
//

import Foundation

protocol ProductDetailCollectionViewViewModelProtocol {
    var images: [String] {get}
}

struct ProductDetailCollectionViewViewModel: ProductDetailCollectionViewViewModelProtocol {
    var images: [String]
}



