//
//  ProductColorSegmentedControl.swift
//  EcommerceConcept
//
//  Created by Артём on 07.12.2022.
//

import Foundation

protocol ProductColorViewModelProtocol {
    var hexStrings: [String] {get set}
}

struct ProductColorViewModel: ProductColorViewModelProtocol {
    var hexStrings: [String]
}

