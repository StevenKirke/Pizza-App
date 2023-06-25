//
//  Meals.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 25.06.2023.
//

import Foundation

struct Meals: Codable {
    let meals: [Meal]
}

struct Meal: Codable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
}
