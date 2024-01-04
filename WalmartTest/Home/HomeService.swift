//
//  HomeService.swift
//  WalmartTest
//
//  Created by Jorge Garay on 03/01/24.
//

import Foundation
final class HomeService: Decodable {
    func getProducts(_ completion: @escaping (Result<ProductResult, Error>) -> Void) {
        let urlRequest = Constants.shared.makeUrlRequest(API.productsURL.rawValue)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            // Check for errors
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            // Check that data has been returned
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ProductResult.self, from: data)
                completion(.success(response))
            } catch let err {
                completion(.failure(NSError(domain: "", code: 0, userInfo: ["userMessage": err.localizedDescription])))
            }
        }
        // execute the HTTP request
        task.resume()
    }
}
