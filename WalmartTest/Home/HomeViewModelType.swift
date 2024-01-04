//
//  HomeViewModelType.swift
//  WalmartTest
//
//  Created by Jorge Garay on 03/01/24.
//

import Foundation
import UIKit

protocol HomeViewModelType: ViewModelType {
    var state: HomeState { get }
    
    func getProducts(_ vc: UIViewController)
    func getSavedProducts()
    func saveProduct(product: ProductsData)
    func deleteProduct(product: ProductsData)
}

enum HomeState: ViewModelStateType {    
    case idle, started([ProductsData])
}
