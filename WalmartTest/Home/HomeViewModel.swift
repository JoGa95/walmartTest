//
//  HomeViewModel.swift
//  WalmartTest
//
//  Created by Jorge Garay on 03/01/24.
//

import Foundation
import UIKit
import CoreData

final class HomeViewModel: BaseViewModel<HomeState>, HomeViewModelType {
    private let homeService: HomeService
    private let managedContext = StorageServices.shared.persistentContainer.viewContext
    
    init(homeService: HomeService) {
        self.homeService = homeService
    }
    func getProducts(_ vc: UIViewController) {
        vc.showLoader()
        self.homeService.getProducts { [weak self] result in
            vc.hideLoder()
            switch result {
            case .success(let productResult):
                self?.state = .started(productResult.products)
            case .failure(let error):
                vc.showAlert(message: AppStrings.errorApi.rawValue + error.localizedDescription)
            }
        }
    }
    
    func saveProduct(product: ProductsData) {
        let localProduct = NSEntityDescription.insertNewObject(forEntityName: "SavedProducts", into: managedContext) as! SavedProducts
        localProduct.id = Int64(product.id)
        localProduct.name = product.title
        localProduct.price = String(product.price)
        do {
            try managedContext.save()
        } catch {
            
        }
    }
    
    func deleteProduct(product: ProductsData) {
        let fetchRequest = NSFetchRequest<SavedProducts>(entityName: "SavedProducts")
        let findProductByIdPredicate = NSPredicate(format: "id   = %ld", product.id)
        
        do {
            fetchRequest.predicate = findProductByIdPredicate
            guard let product = try managedContext.fetch(fetchRequest).first else { return }
            
            managedContext.delete(product)
            
            try managedContext.save()
            self.getSavedProducts()
        } catch {
            
        }
    }

    func getSavedProducts() {
        do {
            var productsList = [ProductsData]()
            let localProducts = try managedContext.fetch(SavedProducts.fetchRequest())
            if localProducts.count > 0 {
                productsList = localProducts.compactMap { ProductsData(id: Int($0.id), title: $0.name ?? "", price: Int($0.price ?? "") ?? 0) }
            }
            
            self.state = .started(productsList)
        } catch {
            // error
        }
    }
}
