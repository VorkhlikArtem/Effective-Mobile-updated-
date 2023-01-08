//
//  CombineNetworkManager.swift
//  EcommerceConcept
//
//  Created by Артём on 08.01.2023.
//

import Foundation
import Combine

final class CombineNetworkManager {
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    
    func getMain() -> AnyPublisher<MainResponse, Error> {
        return fetchData(url: Url.mainUrlSting, type: MainResponse.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getDetail() -> AnyPublisher<ProductDetailModel, Error> {
        return fetchData(url: Url.detailUrlString, type: ProductDetailModel.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getCart() -> AnyPublisher<CartModel, Error> {
        return fetchData(url: Url.cartUrlString, type: CartModel.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func fetchData<T: Decodable>(url: String, type: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: DataFetchingError.invalidUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw DataFetchingError.serverResponseError
                }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { _ in DataFetchingError.decodingError }
            
            .eraseToAnyPublisher()
    }
}
