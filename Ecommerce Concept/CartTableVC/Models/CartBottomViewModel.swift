//
//  CartBottomViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import Foundation

protocol CartBottomViewModelProtocol {
    var totalPrice: Int {get set}
    var deliveryInfo: String {get set}
}

struct CartBottomViewModel: CartBottomViewModelProtocol {
    var totalPrice: Int
    var deliveryInfo: String
}

extension CartBottomViewModel {
    init(from cartModel: CartModel) {
        totalPrice = cartModel.total
        deliveryInfo = cartModel.delivery
    }
}

extension CartBottomViewModelProtocol {
    var formattedPriceString: String {
        return "$\(totalPrice.formattedWithSeparator) us"
    }
}
