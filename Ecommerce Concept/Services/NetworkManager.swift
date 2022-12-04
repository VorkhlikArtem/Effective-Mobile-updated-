//
//  NetworkManager.swift
//  Ecommerce Concept
//
//  Created by Артём on 03.12.2022.
//

import Foundation

class NetworkManager {
    static let mainUrlSting = "https://run.mocky.io/v3/654bd15e-b121-49ba-a588-960956b15175"
    
    func fetchData(url: String, completion: @escaping (MainResponse)->()) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode(MainResponse.self, from: data)
                //print(courses)
                completion(courses)
            } catch let error {
                print("Error serialization json", error)
            }
            
        }.resume()
    }
}
