//
//  URLs.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 25.06.2023.
//

import Foundation


enum URLs {
    case catigories
    case category(_ categoryName: String)
    case meal(_ mealName: String)
    
    var url: String {
        switch self {
            case .catigories:
                return "https://www.themealdb.com/api/json/v1/1/categories.php"
            case .category(let categoryName):
                return "https://www.themealdb.com/api/json/v1/1/filter.php?c=" + categoryName
            case .meal(let mealName):
                return "https://www.themealdb.com/api/json/v1/1/search.php?s=" + mealName
        }
    }
}
