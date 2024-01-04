//
//  HomeModel.swift
//  WalmartTest
//
//  Created by Jorge Garay on 03/01/24.
//

import Foundation

struct ProductResult: Codable {
    let products: [ProductsData]
}

struct ProductsData: Codable {
    let id: Int
    let title: String
    let price: Int
    let savedLocally: Bool = false
}

