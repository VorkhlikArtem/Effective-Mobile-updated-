//
//  CartModel.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import Foundation

struct CartModel: Decodable {
    let basket: [CartItem]
    let delivery: String
    let id: String
    let total: Int
}

struct CartItem: Decodable {
    let id: Int
    let images: String
    let price: Int
    let title: String
}


struct CountableCartModel {
    var basket: [CountableCartItem]
    var delivery: String

    var total: Int
    
    init(from cartModel: CartModel) {
        basket = cartModel.basket.map({CountableCartItem.init(from: $0)})
        delivery = cartModel.delivery
        total = cartModel.total
    }
}

struct CountableCartItem {
    var cartItem: CartItem
    var count: Int
    
    init(from cartItem: CartItem) {
        self.cartItem = cartItem
        count = 1
    }
}



//{
//  "basket": [
//    {
//      "id": 1,
//      "images": "https://www.manualspdf.ru/thumbs/products/l/1260237-samsung-galaxy-note-20-ultra.jpg",
//      "price": 1500,
//      "title": "Galaxy Note 20 Ultra"
//    },
//    {
//      "id": 2,
//      "images": "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-silver-select?wid=470&hei=556&fmt=jpeg&qlt=95&.v=1631652954000",
//      "price": 1800,
//      "title": "iPhone 13"
//    }
//  ],
//  "delivery": "Free",
//  "id": "4",
//  "total": 3300
//}
