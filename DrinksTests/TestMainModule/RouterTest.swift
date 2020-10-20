//
//  RouterTest.swift
//  DrinksTests
//
//  Created by Andrii Zuiok on 18.10.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import XCTest

@testable import Drinks


class MockNavigationController: UINavigationController {
//    var presentedVC: UIViewController?
//
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        self.presentedVC = viewController
//        super.pushViewController(viewController, animated: animated)
//    }
}

class RouterTest: XCTestCase {
    
    var router: RouterProtocol!
    var navigationController = MockNavigationController()
    var builder = ModulesBuilder()

    override func setUp() {
        router = Router(navigationController: navigationController, modulesBuilder: builder)
        
    }

    override func tearDown() {
        router = nil
    }
    
    func testRouter() {
        
        router.showFilter(categories: [], completion: {_ in})
        //let presentedController = navigationController.presentedVC
        
        //XCTAssertTrue(presentedController is FilterViewController)
        XCTAssertTrue(navigationController.viewControllers.last is FilterViewController)
    }


}
