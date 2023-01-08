//
//  CombineCartViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 07.01.2023.
//

import Foundation
import Combine

protocol CombineCartViewModelProtocol {
    var cartItems: [CartCellViewModel] {get}
    var totalCountString: String? {get}
    
    var bottomCartViewModel: CartBottomViewModelProtocol! {get set}
    var fetchDataCallback: ((CombineCartViewModelProtocol) -> Void)? {get set}
    var countChangeCallback: ((String, String?) -> Void)? {get set}
    
    var cartItemsPublisher: AnyPublisher<[CartCellViewModel], Never> {get}
    var bottomCartViewModelPublisher: AnyPublisher<CartBottomViewModelProtocol, Never> {get}
    var totalPriceStringPublisher: AnyPublisher<String, Never> {get}
    var totalCountStringPublisher: AnyPublisher<String?, Never> {get}
    
    func getData()
    func countChanged(indexOfItem: Int, count: Int)
    func deleteItem(at index: Int)
    
}


final class CombineCartViewModel: CombineCartViewModelProtocol  {
    
    var fetchDataCallback: ((CombineCartViewModelProtocol) -> Void)?
    var countChangeCallback: ((String, String?) -> Void)?
    
    let networkManager = DataFetcher()


    @Published var countableCartItems = [CountableCartItem]()
    @Published var bottomCartViewModel: CartBottomViewModelProtocol!
    
    var cartItems: [CartCellViewModel] {
        countableCartItems.map { CartCellViewModel.init(from: $0.cartItem)}
    }
    
    var cartItemsPublisher: AnyPublisher<[CartCellViewModel], Never> {
        $countableCartItems.map { items in
            items.map { CartCellViewModel.init(from: $0.cartItem)}
        }
        .eraseToAnyPublisher()
    }
    
    var bottomCartViewModelPublisher: AnyPublisher<CartBottomViewModelProtocol, Never> {
        $bottomCartViewModel
            .compactMap { $0}
            
            .eraseToAnyPublisher()
    }
    
    
    
    // MARK: - Combine computed properties
    var totalPricePublisher: AnyPublisher<Int, Never> {
        return $countableCartItems.map { items in
            return items.reduce(0) { result, item in
                return result + (item.count * item.cartItem.price)
            }
        }.eraseToAnyPublisher()
    }
    
    var totalPriceStringPublisher: AnyPublisher<String, Never> {
        return totalPricePublisher.map { priceInt in
            return "$\(priceInt.formattedWithSeparator) us"
        }.eraseToAnyPublisher()
    }
    
    var totalCountPublisher: AnyPublisher<Int, Never> {
        return $countableCartItems.map({ items in
            return items.reduce(0) { result, item in
                result + item.count
            }
        }).eraseToAnyPublisher()
    }
    
    var totalCountStringPublisher: AnyPublisher<String?, Never> {
        return totalCountPublisher.map { totalCount in
            return totalCount != 0 ? "\(totalCount)" : nil
        }
        .eraseToAnyPublisher()
    }
    
    
    // MARK: - Usual Properties
    var totalPrice: Int {
       return countableCartItems.reduce(0) { result, item in
           result + (item.count * item.cartItem.price)
       }
    }
    
    var totalCount: Int {
       return countableCartItems.reduce(0) { result, item in
           result + item.count
       }
    }
    
    var totalCountString: String? {
        return totalCount != 0 ? "\(totalCount)" : nil
    }
    
    
    // MARK: - Methods
    
    func getData() {
        networkManager.getCart { [weak self] cartModel in
            guard let cartModel = cartModel, let self = self else {return}
            self.bottomCartViewModel = CartBottomViewModel.init(from: cartModel)
            let countableModel = CountableCartModel.init(from: cartModel)
            self.countableCartItems = countableModel.basket
//            DispatchQueue.main.async {
//                self.fetchDataCallback?(self)
//            }
        }
    }
    
    func countChanged(indexOfItem: Int, count: Int) {
        countableCartItems[indexOfItem].count = count
      
    }
    
    func deleteItem(at index: Int) {
        countableCartItems.remove(at: index)
       
    }
    
}

