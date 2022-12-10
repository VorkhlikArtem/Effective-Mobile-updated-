//
//  NetworkManager.swift
//  Ecommerce Concept
//
//  Created by Артём on 03.12.2022.
//

import Foundation

final class DataFetcher {
    
    func getMain(completion: @escaping (MainResponse?)->()) {
        fetchData(url: Url.mainUrlSting, type: MainResponse.self) { mainResponse in
            completion(mainResponse)
        }
    }
    
    func getDetail(completion: @escaping (ProductDetailModel?)->()) {
        fetchData(url: Url.detailUrlString, type: ProductDetailModel.self) { productDetailModel in
            completion(productDetailModel)
        }
    }
    
    func getCart(completion: @escaping (CartModel?)->()) {
        fetchData(url: Url.cartUrlString, type: CartModel.self) { cartModel in
            completion(cartModel)
        }
    }

    
    func fetchData<T: Decodable>(url: String, type: T.Type, completion: @escaping (T?)->()) {

        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(nil)
                print("Error: ", error.localizedDescription)
            }
            guard let data = data else {
                completion(nil)
                print("No data")
                return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoded = try decoder.decode(T.self, from: data)
                completion(decoded)
            } catch let error {
                completion(nil)
                print("Error serialization json ", error)
            }
            
        }.resume()
    }
    
    
}


