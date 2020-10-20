//
//  Router.swift
//  Drinks
//
//  Created by Andrii Zuiok on 18.10.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import UIKit

protocol RouterProtocol {
    
    func initialViewController()
    func showFilter(categories: [DrinkCategory], completion: @escaping ([DrinkCategory]) -> ())
    func popToRoot()
}

class Router: RouterProtocol {
    
    
    var navigationController: UINavigationController?
    var modulesBuilder: ModulesBuilderProtocol?
    
    init(navigationController: UINavigationController, modulesBuilder: ModulesBuilderProtocol) {
        self.navigationController = navigationController
        self.modulesBuilder = modulesBuilder
    }
    
    func popToRoot() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func initialViewController() {
        if let navigationController = self.navigationController {
            if let mainViewController = modulesBuilder?.buildViewController(router: self) {
                navigationController.viewControllers = [mainViewController]
            }
        }
    }
    
    func showFilter(categories: [DrinkCategory], completion: @escaping ([DrinkCategory]) -> ()) {
        if let navigationController = self.navigationController {
            if let filterViewController = modulesBuilder?.buildFilterViewController(categories: categories, completion: completion, router: self) {
                navigationController.pushViewController(filterViewController, animated: true)
            }
        }
    }
    
    
}
