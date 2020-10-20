//
//  MainPresenter.swift
//  Drinks
//
//  Created by Andrii Zuiok on 14.09.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import UIKit
import Foundation

protocol MainPresenterProtocol: class {
    var viewController: MainViewControllerProtocol? { get set }
    var drinksArray: [Category] { get }
    
    func getImageForIndexPath(indexPath: IndexPath, completion:  @escaping (UIImage?)->())
    func endDisplayingCellAt(indexPath: IndexPath)
    func downloadNextAfter(currentSection: Int)
    func downloadPreviousBefore(currentSection: Int)
    
    func setModel()
    func saveChanges()
    func filterCategories()
    
}

class MainPresenter: MainPresenterProtocol {
    
    var router: RouterProtocol?
    var networkService: NetworkServiceProtocol?
    weak var viewController: MainViewControllerProtocol?

    var cache: NSCache<NSString, UIImage> = NSCache()
    
    var rowDrinksArray: [Category] = []
    var filteredDrinksArray: [Category] { rowDrinksArray.filter({ $0.isVisible }) }
    var drinksArray: [Category] {
        filteredDrinksArray.filter({ $0.drinks == nil ? false : !$0.drinks!.isEmpty })
    }
    
    var drinkCategories: [DrinkCategory]?
    var editedDrinkCategories: [DrinkCategory]?

    init(router: RouterProtocol, networkService: NetworkServiceProtocol) {
        
        self.router = router
        self.networkService = networkService
        
        self.cache.countLimit = 100

        self.setModel()
    }
    
    func setModel() {
        self.networkService?.getAllCategories { drinkCategories in
            self.drinkCategories = drinkCategories
            self.createDrinkArray()
            if let categoryName = self.drinkCategories?.first?.name {
                self.networkService?.getCategoryFor(categoryName: categoryName) { drinks in
                    self.rowDrinksArray[0] = drinks
                    self.viewController?.didFetchData()
                }
            }
            self.viewController?.didFetchData()
        }
    }
    
    private func createDrinkArray() {
        guard let categories = self.drinkCategories else {return}
        for i in 0..<categories.count {
            var category: Category = Category(drinks: nil)
            category.name = categories[i].name
            rowDrinksArray.append(category)
        }
    }
    
    
    func saveChanges() {
        self.drinkCategories = self.editedDrinkCategories
        guard let categories = self.drinkCategories else {return}
        for i in 0..<categories.count {
            self.rowDrinksArray[i].isVisible = categories[i].isActive
            self.viewController?.didFetchData()
        }
    }
    

    
    func downloadNextAfter(currentSection: Int) {
        if currentSection < self.filteredDrinksArray.count - 1 {
            if filteredDrinksArray[currentSection + 1].drinks == nil {
                if let nextCategoryName = self.filteredDrinksArray[currentSection + 1].name {
                    self.networkService?.getCategoryFor(categoryName: nextCategoryName) { drinks in
                        if let index = self.indexInDrinks(nextCategoryName, in: self.rowDrinksArray) {
                            self.rowDrinksArray[index].drinks = drinks.drinks
                        }
                        self.viewController?.didFetchData()
                    }
                }
            }
        }
    }
    
    
    func downloadPreviousBefore(currentSection: Int) {
        if currentSection > 0 {
            if filteredDrinksArray[currentSection - 1].drinks == nil {
                if let previousCategoryName = self.filteredDrinksArray[currentSection - 1].name {
                    self.networkService?.getCategoryFor(categoryName: previousCategoryName) { drinks in
                        if let index = self.indexInDrinks(previousCategoryName, in: self.rowDrinksArray) {
                            self.rowDrinksArray[index].drinks = drinks.drinks
                        }
                        self.viewController?.didFetchData()
                    }
                }
            }
        }
    }
    
    
    func getImageForIndexPath(indexPath: IndexPath, completion:  @escaping (UIImage?)-> ()) {
        
        if let thumb = self.filteredDrinksArray[indexPath.section].drinks?[indexPath.row].thumb, let imageUrl = URL(string: thumb) {
            
//            let cacheId = NSString(string: thumb)
//            if let cachedImage = cache.object(forKey: cacheId) {
//                completion(cachedImage)
//            } else {
                self.networkService?.getImageForUrl(imageUrl: imageUrl, completion: { image in
                    if let downloadedImage = image {
                        completion(downloadedImage)
                        //self.cache.setObject(downloadedImage, forKey: cacheId)
                    }
                })
            //}
        }
    }
    
    
    func endDisplayingCellAt(indexPath: IndexPath) {
        if let thumb = self.filteredDrinksArray[indexPath.section].drinks?[indexPath.row].thumb, let imageUrl = URL(string: thumb) {
            self.networkService?.endDownload(url: imageUrl)
        }
    }
    
    func filterCategories() {
        if let categories = self.drinkCategories {
            let completion: ([DrinkCategory])->() = { [weak self] categories in
                    guard let self = self else {return}
                    self.editedDrinkCategories = categories
                    self.saveChanges()
            }
            router?.showFilter(categories: categories, completion: completion)
        }
    }
        
    private func indexInDrinks(_ name: String?, in drinksArray: [Category]?) -> Int? {
        guard let name = name else {return nil}
        guard let categories = drinksArray else {return nil}
        for i in 0..<categories.count {
            if categories[i].name == name {
                return i
            }
        }
        return nil
    }
    
    /*
    private func indexInCategories(_ name: String?, in categoriesArray: [DrinkCategory]?) -> Int? {
        guard let name = name else {return nil}
        guard let categories = categoriesArray else {return nil}
        for i in 0..<categories.count {
            if categories[i].name == name {
                return i
            }
        }
        return nil
    }
    */
}




