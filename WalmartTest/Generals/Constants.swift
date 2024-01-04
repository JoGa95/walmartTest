//
//  Constants.swift
//  WalmartTest
//
//  Created by Jorge Garay on 03/01/24.
//

import Foundation

enum AppStrings: String {
    case loading = "Loading..."
    case ok = "OK"
    case errorApi = "An error occurs, please try again..."

    enum HomeScreen: String {
        case sumLabel = "The sum of random numbers is: @"
        case saveTitle = "Click to save products"
        case deleteTitle = "Click to delete products"
    }
}

enum API: String {
    case productsURL = "https://dummyjson.com/products"
}

class Constants: NSObject {
    static let shared = Constants()
    func makeUrlRequest(_ url: String) -> URLRequest {
        let url = URL(string: url)
        return URLRequest(url: url!)
    }
}
