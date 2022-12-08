//
//  CartCellViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 09.12.2022.
//

import Foundation

struct CartCellViewModel {
  //  let count: Int
    let images: String
    let price: Int
    let title: String
}

extension CartCellViewModel {
    init(from cartItemModel: CartItem) {
        images = cartItemModel.images
        price = cartItemModel.price
        title = cartItemModel.title
     //   count = 1
    }
}
