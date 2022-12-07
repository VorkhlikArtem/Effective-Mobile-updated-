//
//  ProductCapacityViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 07.12.2022.
//

import Foundation

protocol ProductCapacityViewModelProtocol {
    var capacities: [String] {get set}
}

struct ProductCapacityViewModel: ProductCapacityViewModelProtocol {
    var capacities: [String]
    
}

extension ProductCapacityViewModelProtocol {
    var formatedCapacities: [String] {
        capacities.map { $0 + " GB"}
    }
}
