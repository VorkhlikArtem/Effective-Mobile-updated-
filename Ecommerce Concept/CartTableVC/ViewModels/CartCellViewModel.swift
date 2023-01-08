//
//  CartCellViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 09.12.2022.
//

import Foundation

struct CartCellViewModel {

    let images: String
    let price: Int
    let title: String
    let count: Int
}

extension CartCellViewModel {
    init(from cartItemModel: CountableCartItem) {
        images = cartItemModel.cartItem.images
        price = cartItemModel.cartItem.price
        title = cartItemModel.cartItem.title
        count = cartItemModel.count
    }
}

extension CartCellViewModel {
    var formattedPrice: String {
         return "$" + String(format: "%.02f", Float(price))
    }
}
