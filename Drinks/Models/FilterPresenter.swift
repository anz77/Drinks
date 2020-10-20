//
//  FilterPresenter.swift
//  Drinks
//
//  Created by Andrii Zuiok on 18.10.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation

protocol FilterPresenterProtocol: class {
    
    var saveCompletion: ([DrinkCategory])->()  { get set }
    var categories: [DrinkCategory] { get set }
    
    func save()
}


class FilterlPresenter: FilterPresenterProtocol {
    
    var router: RouterProtocol?
    
    var categories: [DrinkCategory]
    var saveCompletion: ([DrinkCategory]) -> ()
        
    init(categories: [DrinkCategory], saveCompletion: @escaping ([DrinkCategory]) -> (), router: RouterProtocol) {
        self.router = router
        self.categories = categories
        self.saveCompletion = saveCompletion
    }
    
    func save() {
        saveCompletion(categories)
    }
    
    deinit {
        print("presenter deinit")
    }
    
    
    
}
