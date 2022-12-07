//
//  ProductFeaturesViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 06.12.2022.
//

import Foundation

protocol ProductFeaturesViewModelProtocol {
    var productFeatures: [ProductFeature] {get set}
}

struct ProductFeature {
    var name: String
    var imageName: String
}

struct ProductFeaturesViewModel: ProductFeaturesViewModelProtocol {
    var productFeatures: [ProductFeature]
}

extension ProductFeaturesViewModel {
    init(productDetailBottomViewModel: ProductDetailBottomViewModelProtocol) {
        productFeatures = [ProductFeature(name: productDetailBottomViewModel.CPU,
                                        imageName: "CPU"),
                     ProductFeature(name: productDetailBottomViewModel.camera,
                                                     imageName: "camera"),
                     ProductFeature(name: productDetailBottomViewModel.ssd,
                                                     imageName: "ssd"),
                     ProductFeature(name: productDetailBottomViewModel.sd,
                                                     imageName: "sd"),
                     ]
    }
}
