//
//  DrinksCategories.swift
//  Drinks
//
//  Created by Andrii Zuiok on 14.09.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation

// MARK: - DrinksCategories
public struct DrinksCategories: Codable {
    public var drinksCategories: [DrinkCategory]?

    enum CodingKeys: String, CodingKey {
        case drinksCategories = "drinks"
    }

    public init(drinksCategories: [DrinkCategory]?) {
        self.drinksCategories = drinksCategories
    }
}

// MARK: - DrinkCategory
public struct DrinkCategory: Codable {
    public var name: String?
    
    // for displaying in table view
    public var isActive: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case name = "strCategory"
    }

    public init(name: String?) {
        self.name = name
    }
}

