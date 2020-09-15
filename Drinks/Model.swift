//
//  Model.swift
//  Drinks
//
//  Created by Andrii Zuiok on 14.09.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation

class Model {
    
    weak var delegate: ModelFetchDataDelegate?
    
    let baseUrlString = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    var drinksArray: [Drinks] = [] {
        didSet {
            //print(drinksArray)
        }
    }
    
    var filteredDrinksArray: [Drinks] { drinksArray.filter({ $0.isVisible }) }
    
    var categories: [DrinkCategory]? {
        didSet {
            //categories?.forEach({ print("category name: \($0.name!) \tisActive: \($0.isActive)") })
        }
    }
    
    var editCategories: [DrinkCategory]? {
        didSet {}
    }
    
    func createDrinkArray() {
        guard let categories = self.categories else {return}
        for i in 0..<categories.count {
            var drinks: Drinks = Drinks(drinks: nil)
            drinks.categoryName = categories[i].name
            drinksArray.append(drinks)
        }
    }
    
    
    init() {
        self.getCategories { categories in
            self.categories = categories
            
            self.createDrinkArray()
            if let categoryName = self.categories?.first?.name {
                
                self.getDrinksFor(category: categoryName) { drinks in
                    self.drinksArray[0].drinks = drinks.drinks
                    self.delegate?.didFetchData()
                }
            }
            self.delegate?.didFetchData()
        }
    }
    
    
    func saveChanges() {

        self.categories = self.editCategories
        
        guard let categories = self.categories else {return}
       
        for i in 0..<categories.count {
            
            self.drinksArray[i].isVisible = categories[i].isActive
            self.delegate?.didFetchData()
        }
        
        //self.editCategories = nil
    }
    
    
    func getCategories(completion: @escaping ([DrinkCategory]?)->()) {
        let urlString = baseUrlString + "list.php?c=list"
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                let drinksCategories = try JSONDecoder().decode(DrinksCategories.self, from: data)
                
                if let categories = drinksCategories.drinksCategories {
                    DispatchQueue.main.async {
                        completion(categories)
                    }
                } else {
                    completion(nil)
                }
            } catch {}
        }.resume()
    }
    
    func getDrinksFor(category: String, completion: @escaping (Drinks)->()) {
        
        let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let urlString = baseUrlString + "filter.php?c=\(encodedCategory)"
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                var drinks = try JSONDecoder().decode(Drinks.self, from: data)
                drinks.categoryName = category
                DispatchQueue.main.async {
                    completion(drinks)
                }
                
            } catch {}
        }.resume()
    }
    
    func indexInCategories(_ name: String?, in categoriesArray: [DrinkCategory]?) -> Int? {
        guard let name = name else {return nil}
        guard let categories = categoriesArray else {return nil}
        for i in 0..<categories.count {
            if categories[i].name == name {
                return i
            }
        }
        return nil
    }
    
    func indexInDrinks(_ name: String?, in drinksArray: [Drinks]?) -> Int? {
        guard let name = name else {return nil}
        guard let categories = drinksArray else {return nil}
        for i in 0..<categories.count {
            if categories[i].categoryName == name {
                return i
            }
        }
        return nil
    }
    
    func downloadNextAfter(currentIndex: Int) {
    
        if currentIndex < self.filteredDrinksArray.count - 1 {
            
            if filteredDrinksArray[currentIndex + 1].drinks == nil {
                
                if let nextCategoryName = self.filteredDrinksArray[currentIndex + 1].categoryName {
                    self.getDrinksFor(category: nextCategoryName) { drinks in
                        if let index = self.indexInDrinks(nextCategoryName, in: self.drinksArray) {
                            self.drinksArray[index].drinks = drinks.drinks
                        }
                        self.delegate?.didFetchData()
                    }
                }
            }
        }
    }
    
}

protocol ModelFetchDataDelegate: class {
    func didFetchData()
}


