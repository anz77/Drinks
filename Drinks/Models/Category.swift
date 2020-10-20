//
//  Category.swift
//  Drinks
//
//  Created by Andrii Zuiok on 14.09.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation


// MARK: - Category
public struct Category: Codable {
    
    var name: String?
    var isVisible: Bool = true
    
    public var drinks: [Drink]?

    enum CodingKeys: String, CodingKey {
        case drinks = "drinks"
    }

    public init(drinks: [Drink]?) {
        self.drinks = drinks
    }
}

// MARK: - Drink
public struct Drink: Codable {
    public var name: String?
    public var thumb: String?
    public var id: String?

    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case thumb = "strDrinkThumb"
        case id = "idDrink"
    }

    public init(name: String?, thumb: String?, id: String?) {
        self.name = name
        self.thumb = thumb
        self.id = id
    }
}
