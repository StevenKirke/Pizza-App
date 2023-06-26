//
//  ContentViewModel.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 24.06.2023.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    private var requestData: RequestData = RequestData()
    private var workUserDefaults: WorkUserDefaults = WorkUserDefaults()
    
    @Published var isLoad: Bool = false
    @Published var isUserDefault: Bool = false
    
    @Published var backInMenu: Bool = false
    @Published var itemNenu: CustomTabBar = CustomTabBar.menu
    @Published var modelCategoties: Categories = Categories(categories: [])
    @Published var modelMeals: Meals = Meals(meals: [])
    
    @Published var modelMealDescription: MealDescription = MealDescription(meals: [["" : ""]])
    
    @Published var categoryAndMealList: [CategoryForList] = []
    
    //@Published var currentIndex: Int = 0
    
    init() {
        getCategories()
    }
    
    private func getCategories() {
        self.requestData.getData(url: URLs.catigories.url, model: modelCategoties) { [weak self] data, error in
            if error != "" {
                print("errors \(String(describing: error))")
            }
            guard let currentData = data else {
                return
            }
            guard let self = self else {
                return
            }
            
            self.modelCategoties = currentData
            addListCategory()
            getMeals {
                self.getDiscriptionMeal() {
                    self.isLoad = true
                    //self.saveImage()
                }
            }
        }
    }
    
    
    private func getMeals(returnArray: @escaping () -> Void) {
        if !categoryAndMealList.isEmpty {
            for (index, elem) in categoryAndMealList.enumerated() {
                self.requestData.getData(url: URLs.category(elem.categoryName).url, model: modelMeals) { [weak self] data, error in
                    if error != "" {
                        print("errors \(String(describing: error))")
                    }
                    guard let currentData = data else {
                        return
                    }
                    guard let self = self else {
                        return
                    }
                    if !currentData.meals.isEmpty {
                        for(ind, meal) in currentData.meals.enumerated() {
                            self.categoryAndMealList[index].listMeals.append(ListMeals(categoryName: elem.categoryName,
                                                                                       mealName: meal.strMeal,
                                                                                       imageUrl: meal.strMealThumb.trim(),
                                                                                       imageData: Data(),
                                                                                       description: ""))
                            if ind > 10 {
                                break
                            }
                        }
                    }
                    if index == categoryAndMealList.count - 1 {
                        return returnArray()
                    }
                }
            }
        }
    }
    
    private func saveImage() {
        if !categoryAndMealList.isEmpty {
            for (index, _) in self.categoryAndMealList.enumerated() {
                for (ind, meal) in self.categoryAndMealList[index].listMeals.enumerated() {
                    self.requestData.getImage(url: meal.imageUrl) { data in
                        guard let currentData = data else {
                            return
                        }
                        DispatchQueue.main.async {
                            self.categoryAndMealList[index].listMeals[ind].imageData = currentData
                        }
                    }
                }
            }
        }
    }
    
    
    private func getDiscriptionMeal(result: @escaping () -> Void) {
        if !categoryAndMealList.isEmpty {
            for (index, _) in self.categoryAndMealList.enumerated() {
                for (int, meal) in self.categoryAndMealList[index].listMeals.enumerated() {
                    var descriptions: String = ""
                    let assamblyUrl = URLs.meal(meal.mealName).url.replace()
                    self.requestData.getData(url: assamblyUrl, model: modelMealDescription) { [weak self] data, error in
                        if error != "" {
                            print("errors \(String(describing: error))")
                        }
                        
                        guard let currentData = data?.meals.first else {
                            return
                        }
                        
                        guard let self = self else {
                            return
                        }
                        for i in 1...20 {
                            let assablyKey = "strIngredient\(i)"
                            self.enumirateKey(currentKey: assablyKey, array: currentData) { (isSearch, name) in
                                guard let currentName = name else {
                                    return
                                }
                                if currentName != "" {
                                    if i == 1 {
                                        descriptions += currentName + "."
                                    } else {
                                        descriptions += " " + currentName + "."
                                    }
                                }
                            }
                        }
                        self.categoryAndMealList[index].listMeals[int].description = descriptions
                    }
                }
            }
            return result()
        }
    }
    
    private func enumirateKey(currentKey: String, array: [String : String?], returnKey: (Bool, String?) -> Void) {
        for (_, elem) in array.enumerated() {
            if elem.key == currentKey {
                guard let nameKey = elem.value else {
                    return returnKey(false, nil)
                }
                return returnKey(true, "\(nameKey)")
            }
        }
        return returnKey(false, nil)
    }
    
    
    private func addListCategory() {
        
        if !modelCategoties.categories.isEmpty {
            for (index, elem) in modelCategoties.categories.enumerated() {
                if index <= 6 {
                    categoryAndMealList.append(CategoryForList(categoryName: elem.strCategory.trim(), listMeals: []))
                }
            }
        }
//        guard let name = categoryAndMealList.first?.categoryName else {
//            return
//        }
        //self.currentLabel = name
    }
    /*
    func saveData() {
        self.workUserDefaults.saveUserDefault(currentData: categoryAndMealList)
        print("save user data")
        self.isUserDefault = true
    }
    
    func loadData() {
        DispatchQueue.main.async {
            guard let userDefault = self.workUserDefaults.writeUserDefault(model: self.categoryAndMealList) else {
                print("Error load user default")
                return
            }
            self.categoryAndMealList = userDefault
            print(self.categoryAndMealList)
        }
    }
    
    func removeData() {
        self.workUserDefaults.removeUserDefault()
        print("delete user data")
    }
    
    func removeAllData() {
        self.categoryAndMealList = []
    }
    */
}
