//
//  NetworkManager.swift
//  Ecommerce Concept
//
//  Created by Артём on 03.12.2022.
//

import Foundation

class NetworkManager {
    static let mainUrlSting = "https://run.mocky.io/v3/654bd15e-b121-49ba-a588-960956b15175"
    static let detailUrlString = "https://run.mocky.io/v3/6c14c560-15c6-4248-b9d2-b4508df7d4f5"
    static let cartUrlString = "https://run.mocky.io/v3/53539a72-3c5f-4f30-bbb1-6ca10d42c149"
    
    func fetchData<T: Decodable>(url: String, type: T.Type, completion: @escaping (T)->()) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode(T.self, from: data)
                print(courses)
                completion(courses)
            } catch let error {
                print("Error serialization json", error)
            }
            
        }.resume()
    }
}
