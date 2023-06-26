//
//  ListCategoryAndMeals.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 25.06.2023.
//

import Foundation


struct CategoryForList: Codable {
    let categoryName: String
    var listMeals: [ListMeals]
}

struct ListMeals: Codable {
    var categoryName: String
    var mealName: String
    var imageUrl: String
    var imageData : Data
    var description: String
}
