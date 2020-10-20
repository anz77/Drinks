//
//  MainPresenterTest.swift
//  DrinksTests
//
//  Created by Andrii Zuiok on 18.10.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import XCTest

@testable import Drinks

class MockView: MainViewControllerProtocol {
    func didFetchData() {}
}

class MockNetworkService: NetworkServiceProtocol {
    var drinkCategories: [DrinkCategory]!
    var category: Drinks.Category!
    
    init() {}
    
    convenience init(drinkCategories: [DrinkCategory]?, category: Drinks.Category?) {
        self.init()
        self.drinkCategories = drinkCategories
        self.category = category
    }
    
    func getAllCategories(completion: @escaping ([DrinkCategory]?) -> ()) {
        if let drinkCategories = drinkCategories {
            completion(drinkCategories)
        }
    }
    func getCategoryFor(categoryName: String, completion: @escaping (Drinks.Category) -> ()) {
        if let category = category {
            completion(category)
        }
    }
    
    func getImageForUrl(imageUrl: URL, completion: @escaping (UIImage?) -> ()) {}
    func endDownload(url: URL) {}
    
}

class MainPresenterTests: XCTestCase {
    
    var view: MockView!
    var presenter: MainPresenter!
    var router: RouterProtocol!
    var networkService: MockNetworkService!
    var drinkCategories = [DrinkCategory]()
    var categories: [Drinks.Category] = []
    

    override func setUp() {
        view = MockView()
        let navigationController = UINavigationController()
        router = Router(navigationController: navigationController, modulesBuilder: ModulesBuilder())
    }

    override func tearDown() {
        view = nil
        presenter = nil
        networkService = nil
        router = nil
    }
    
    func testGetSuccessCategories() {
        let drinkCategory = DrinkCategory(name: "Some Drinks")
        drinkCategories.append(drinkCategory)
        
        let category = Drinks.Category(drinks: [Drink(name: "Foo", thumb: "https://some.com", id: "1234")])
        categories.append(category)
        
        networkService = MockNetworkService(drinkCategories: [drinkCategory], category: category)
        presenter = MainPresenter(router: router, networkService: networkService)
        presenter.viewController = view
        
        XCTAssertNotEqual(presenter?.drinksArray.count, 0)
        XCTAssertEqual(presenter?.drinksArray.count, 1)
        XCTAssertEqual(presenter?.drinksArray[0].drinks?[0].thumb, "https://some.com")
    }
    
    func testGetFailureCategories() {
        
        networkService = MockNetworkService()
        presenter = MainPresenter(router: router, networkService: networkService)
        presenter.viewController = view
        
        XCTAssertEqual(presenter?.drinksArray.count, 0)
    }

}
