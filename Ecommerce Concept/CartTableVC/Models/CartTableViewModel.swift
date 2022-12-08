//
//  CartTableViewModel.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import Foundation

protocol CartTableViewModelProtocol {
    var cartItems: [CartCellViewModel] {get}
    var bottomCartViewModel: CartBottomViewModelProtocol {get}
    var fetchDataCallback: ((CartTableViewModelProtocol) -> Void)? {get set}
    var countChangeCallback: ((String) -> Void)? {get set}
    func countChanged(indexOfItem: Int, count: Int)
    
}


class CartTableViewModel: CartTableViewModelProtocol  {
    private var model: CartModel!
    
    private var countableModel: CountableCartModel!
    
    var cartItems: [CartCellViewModel] {
        model.basket.map { CartCellViewModel.init(from: $0)}
    }
    
    var bottomCartViewModel: CartBottomViewModelProtocol {
        CartBottomViewModel.init(from: model)
    }
    
    var totalPrice: Int {
       return countableModel.basket.reduce(0) { result, item in
           result + (item.count * item.cartItem.price)
       }
    }
    
    var totalCount: Int {
       return countableModel.basket.reduce(0) { result, item in
           result + item.count
       }
    }
    
    
    var fetchDataCallback: ((CartTableViewModelProtocol) -> Void)?
    var countChangeCallback: ((String) -> Void)?
    
    let networkManager = NetworkManager()
    
    init() {
        networkManager.fetchData(url: NetworkManager.cartUrlString, type: CartModel.self, completion: { cartModel in
           print(cartModel)
            self.model = cartModel
            self.countableModel = CountableCartModel.init(from: cartModel)
            DispatchQueue.main.async {
                self.fetchDataCallback?(self)
            }
           
        })
        
//        let mainResponse = Bundle.main.decode(CartModel.self, from: "cart.json")
//        print(mainResponse)
//        self.model = mainResponse
//        self.fetchDataCallback?(self)
    }
    
    func countChanged(indexOfItem: Int, count: Int) {
        countableModel.basket[indexOfItem].count = count
        countChangeCallback?("$\(totalPrice.formattedWithSeparator) us")
    }
    
    
}
