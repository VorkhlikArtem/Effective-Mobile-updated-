//
//  MainViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 11.12.2022.
//

import Foundation

enum MainViewModel {
    enum Section: String, Hashable, CaseIterable {
        case selectCategorySection = "Select Category"
        case hotSalesSection = "Hot Sales"
        case bestSellersSection = "Best Seller"
    }
    enum Item : Hashable {
        case selectCategoryItem(category: CategoryItem  )
        case hotSalesItem(hotSalesItem: HotSalesItem)
        case bestSellerItem(bestSellersItem: BestSellersItem)
        
        func hash(into hasher: inout Hasher) {
            switch self {
            
            case .selectCategoryItem(let category):
                hasher.combine(category.title )
            case .hotSalesItem(let hotSalesItem):
                hasher.combine(hotSalesItem.id)
            case .bestSellerItem(let bestSellersItem):
                hasher.combine(bestSellersItem.id)
            }
        }
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            switch (lhs, rhs) {
            case (.selectCategoryItem(let lCategory) , .selectCategoryItem(let rCategory)):
                return lCategory.title == rCategory.title
            case (.hotSalesItem(let lHotSalesItem), .hotSalesItem(let rHotSalesItem) ):
                return lHotSalesItem.id == rHotSalesItem.id
            case (.bestSellerItem(let lBestSellersItem), .bestSellerItem(let rBestSellersItem)):
                return lBestSellersItem.id == rBestSellersItem.id
            default: return false
            }
        }
    }
}
