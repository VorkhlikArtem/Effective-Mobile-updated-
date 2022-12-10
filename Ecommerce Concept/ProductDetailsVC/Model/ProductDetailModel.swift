//
//  ProductDetailModel.swift
//  EcommerceConcept
//
//  Created by Артём on 06.12.2022.
//

import Foundation

struct ProductDetailModel: Decodable {
    let CPU: String
    let camera: String
    let capacity: [String]
    let color: [String]
    let id: String
    let images: [String]
    let isFavorites: Bool
    let price: Int
    let rating: Float
    let sd: String
    let ssd: String
    let title: String
    
}


//{
//  "CPU": "Exynos 990",
//  "camera": "108 + 12 mp",
//  "capacity": [
//    "126",
//    "252"
//  ],
//  "color": [
//    "#772D03",
//    "#010035"
//  ],
//  "id": "3",
//  "images": [
//    "https://avatars.mds.yandex.net/get-mpic/5235334/img_id5575010630545284324.png/orig",
//    "https://www.manualspdf.ru/thumbs/products/l/1260237-samsung-galaxy-note-20-ultra.jpg"
//  ],
//  "isFavorites": true,
//  "price": 1500,
//  "rating": 4.5,
//  "sd": "256 GB",
//  "ssd": "8 GB",
//  "title": "Galaxy Note 20 Ultra"
//}
