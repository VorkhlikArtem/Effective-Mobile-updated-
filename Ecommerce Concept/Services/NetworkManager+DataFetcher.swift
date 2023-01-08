//
//  NetworkManager.swift
//  Ecommerce Concept
//
//  Created by Артём on 03.12.2022.
//

import Foundation
import Combine

final class DataFetcher {
    
    func getMain(completion: @escaping (MainResponse?)->()) {
        fetchData(url: Url.mainUrlSting, type: MainResponse.self) { mainResponse in
            DispatchQueue.main.async {
                completion(mainResponse)
            }
        }
    }
    
    func getDetail(completion: @escaping (ProductDetailModel?)->()) {
        fetchData(url: Url.detailUrlString, type: ProductDetailModel.self) { productDetailModel in
            DispatchQueue.main.async {
                completion(productDetailModel)
            }
        }
    }
    
    func getCart(completion: @escaping (CartModel?)->()) {
        fetchData(url: Url.cartUrlString, type: CartModel.self) { cartModel in
            DispatchQueue.main.async {
                completion(cartModel)
            }
        }
    }

    
    private func fetchData<T: Decodable>(url: String, type: T.Type, completion: @escaping (T?)->()) {

        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error: ", error.localizedDescription)
                completion(nil)
            }
            guard let data = data else {
                print("No data from the server")
                completion(nil)
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
    
    private func fetchData1<T: Decodable>(url: String, type: T.Type) -> AnyPublisher<T, Error> {
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
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func getMain1() -> AnyPublisher<MainResponse, Error> {
        return fetchData1(url: Url.mainUrlSting, type: MainResponse.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

enum DataFetchingError: Error, LocalizedError {
    case invalidUrl
    case serverResponseError
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .serverResponseError:
            return "Error from server"
        case .decodingError:
            return "Error while parsing"
        }
    }
}


