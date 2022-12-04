//
//  Models.swift
//  Ecommerce Concept
//
//  Created by Артём on 03.12.2022.
//

import Foundation

struct MainResponse: Decodable {
    var homeStore: [HotSalesItem]
    var bestSeller: [BestSellersItem]
}


struct HotSalesItem: Decodable {
    var id: Int
    var isNew: Bool?
    var title: String
    var subtitle: String
    var picture: String
    var isBuy: Bool
   
}


struct BestSellersItem: Decodable {
    var id: Int
    var isFavorites: Bool
    var title: String
    var priceWithoutDiscount: Int
    var discountPrice: Int
    var picture: String
}

