//
//  ProductDetailBottomViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 06.12.2022.
//

import Foundation

protocol ProductDetailBottomViewModelProtocol {
    var CPU: String {get set}
    var camera: String {get set}
    var capacity: [String] {get set}
    var color: [String] {get set}
    var isFavorites: Bool {get set}
    var price: Int {get set}
    var rating: Float {get set}
    var sd: String {get set}
    var ssd: String {get set}
    var title: String {get set}
}

struct ProductDetailBottomViewModel: ProductDetailBottomViewModelProtocol {
    var CPU: String
    var camera: String
    var capacity: [String]
    var color: [String]
    var isFavorites: Bool
    var price: Int
    var rating: Float
    var sd: String
    var ssd: String
    var title: String
}

extension ProductDetailBottomViewModel {
    init(productDetailModel: ProductDetailModel) {
        CPU = productDetailModel.CPU
        camera = productDetailModel.camera
        capacity = productDetailModel.capacity
        color = productDetailModel.color
        isFavorites = productDetailModel.isFavorites
        price = productDetailModel.price
        rating = productDetailModel.rating
        sd = productDetailModel.sd
        ssd = productDetailModel.ssd
        title = productDetailModel.title
    }
    
   
}

extension ProductDetailBottomViewModelProtocol {
    var formatedPrice: String {
        return "$" + price.formattedWithSeparator + ".00"
    }
}
