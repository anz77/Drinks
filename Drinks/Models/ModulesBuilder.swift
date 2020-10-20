//
//  ModulesBuilder.swift
//  Drinks
//
//  Created by Andrii Zuiok on 17.10.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation

protocol ModulesBuilderProtocol {
    func buildViewController(router: RouterProtocol) -> MainViewController
    func buildFilterViewController(categories: [DrinkCategory], completion: @escaping ([DrinkCategory])->(), router: RouterProtocol) -> FilterViewController
}

class ModulesBuilder: ModulesBuilderProtocol {
    
    func buildViewController(router: RouterProtocol) -> MainViewController {
        let networkService = NetworkService()
        let presenter = MainPresenter(router: router, networkService: networkService)
        let viewController = MainViewController(presenter: presenter)
        return viewController
    }
    
    func buildFilterViewController(categories: [DrinkCategory], completion: @escaping ([DrinkCategory])->(), router: RouterProtocol) -> FilterViewController {
        let presenter = FilterlPresenter(categories: categories, saveCompletion: completion, router: router)
        let viewController = FilterViewController(presenter: presenter)
        return viewController
    }
}

