//
//  ProductFeaturesViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 06.12.2022.
//

import Foundation

protocol ProductFeaturesViewModelProtocol {
    var CPU: String {get set}
    var camera: String {get set}
 
    var sd: String {get set}
    var ssd: String {get set}
  
}

struct ProductFeaturesViewModel: ProductFeaturesViewModelProtocol {
    var CPU: String
    var camera: String
   
    var sd: String
    var ssd: String
 
}

extension ProductFeaturesViewModel {
    init(productDetailBottomViewModel: ProductDetailBottomViewModelProtocol) {
        CPU = productDetailBottomViewModel.CPU
        camera = productDetailBottomViewModel.camera
        sd = productDetailBottomViewModel.sd
        ssd = productDetailBottomViewModel.ssd
    }
}
