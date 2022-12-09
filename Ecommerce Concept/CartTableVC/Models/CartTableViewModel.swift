//
//  CartTableViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import Foundation

protocol CartTableViewModelProtocol {
    var cartItems: [CartCellViewModel] {get}
    var totalCountString: String? {get}
    
    var bottomCartViewModel: CartBottomViewModelProtocol! {get set}
    var fetchDataCallback: ((CartTableViewModelProtocol) -> Void)? {get set}
    var countChangeCallback: ((String, String?) -> Void)? {get set}
    
    func getData()
    func countChanged(indexOfItem: Int, count: Int)
    func deleteItem(at index: Int)
    
}


class CartTableViewModel: CartTableViewModelProtocol  {


    var countableCartItems = [CountableCartItem]() {
        didSet {
            let totalPriceString = "$\(totalPrice.formattedWithSeparator) us"
            let totalCountString = totalCount != 0 ? "\(totalCount)" : nil
            countChangeCallback?(totalPriceString, totalCountString)
            
        }
    }
    
    var cartItems: [CartCellViewModel] {
        countableCartItems.map { CartCellViewModel.init(from: $0.cartItem)}
    }
    
    var bottomCartViewModel: CartBottomViewModelProtocol!
    
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
    
    
    var fetchDataCallback: ((CartTableViewModelProtocol) -> Void)?
    var countChangeCallback: ((String, String?) -> Void)?
    
    let networkManager = NetworkManager()
    
//    init() {
//        networkManager.fetchData(url: NetworkManager.cartUrlString, type: CartModel.self, completion: { cartModel in
//          // print(cartModel)
//            self.bottomCartViewModel = CartBottomViewModel.init(from: cartModel)
//
//            let countableModel = CountableCartModel.init(from: cartModel)
//            self.countableCartItems = countableModel.basket
//
//            //self.cartItems = countableModel.basket.map { CartCellViewModel.init(from: $0.cartItem)}
//
//            DispatchQueue.main.async {
//                self.fetchDataCallback?(self)
//
////                let totalPriceString = "$\(self.totalPrice.formattedWithSeparator) us"
////                let totalCountString = self.totalCount != 0 ? "\(self.totalCount)" : nil
////                self.countChangeCallback?(totalPriceString, totalCountString)
//            }
//
//        })
//    }
    
    func getData() {
        networkManager.fetchData(url: NetworkManager.cartUrlString, type: CartModel.self, completion: { cartModel in
            self.bottomCartViewModel = CartBottomViewModel.init(from: cartModel)
            let countableModel = CountableCartModel.init(from: cartModel)
            self.countableCartItems = countableModel.basket
            DispatchQueue.main.async {
                self.fetchDataCallback?(self)
            }
        })
    }
    
    func countChanged(indexOfItem: Int, count: Int) {
        countableCartItems[indexOfItem].count = count
      
    }
    
    func deleteItem(at index: Int) {
        countableCartItems.remove(at: index)
       
    }
    
}
