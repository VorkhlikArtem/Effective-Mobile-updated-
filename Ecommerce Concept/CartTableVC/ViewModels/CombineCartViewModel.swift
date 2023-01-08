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

    var totalCountAndPriceStringPublisher: AnyPublisher<(String, String?), Never> {get}
    var cartItemsPublisher: AnyPublisher<[CartCellViewModel], Never> {get}
    var bottomCartViewModelPublisher: AnyPublisher<CartBottomViewModelProtocol, Never> {get}
    
    func getData()
    func countChanged(indexOfItem: Int, count: Int)
    func deleteItem(at index: Int)
    
}


final class CombineCartViewModel: CombineCartViewModelProtocol  {
    
    private let networkManager = CombineNetworkManager()
    private var cancellable: AnyCancellable?

    // MARK: - Combine View Models Publishers
    
    @Published private var countableCartItems = [CountableCartItem]()
    @Published private var bottomCartViewModel: CartBottomViewModelProtocol!
    
    var cartItems: [CartCellViewModel] {
        return countableCartItems.map { CartCellViewModel.init(from: $0)}
    }
    
    var cartItemsPublisher: AnyPublisher<[CartCellViewModel], Never> {
        $countableCartItems.flatMap { _ in Just(self.cartItems) }
        .eraseToAnyPublisher()
    }
    
    var bottomCartViewModelPublisher: AnyPublisher<CartBottomViewModelProtocol, Never> {
        $bottomCartViewModel.compactMap {$0}.eraseToAnyPublisher()
    }
    
    
    // MARK: - Combine Price And Count Publishers
    
    var totalCountAndPriceStringPublisher: AnyPublisher<(String, String?), Never> {
        Publishers.CombineLatest(totalPriceStringPublisher, totalCountStringPublisher)
            .eraseToAnyPublisher()
    }
    
    private var totalPricePublisher: AnyPublisher<Int, Never> {
        return $countableCartItems.map { items in
            return items.reduce(0) { result, item in
                return result + (item.count * item.cartItem.price)
            }
        }.eraseToAnyPublisher()
    }
    
    private var totalPriceStringPublisher: AnyPublisher<String, Never> {
        return totalPricePublisher.map { priceInt in
            return "$\(priceInt.formattedWithSeparator) us"
        }.eraseToAnyPublisher()
    }
    
    private var totalCountPublisher: AnyPublisher<Int, Never> {
        return $countableCartItems.map({ items in
            return items.reduce(0) { result, item in
                result + item.count
            }
        }).eraseToAnyPublisher()
    }
    
    private var totalCountStringPublisher: AnyPublisher<String?, Never> {
        return totalCountPublisher.map { totalCount in
            return totalCount != 0 ? "\(totalCount)" : nil
        }
        .eraseToAnyPublisher()
    }
    
    
    // MARK: - Methods
    
    func getData() {
        cancellable = networkManager.getCart()
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] cartModel in
                guard let self = self else {return}
                self.bottomCartViewModel = CartBottomViewModel.init(from: cartModel)
                let countableModel = CountableCartModel.init(from: cartModel)
                self.countableCartItems = countableModel.basket
            }
    }
    
    func countChanged(indexOfItem: Int, count: Int) {
        countableCartItems[indexOfItem].count = count
    }
    
    func deleteItem(at index: Int) {
        countableCartItems.remove(at: index)
    }
    
}

