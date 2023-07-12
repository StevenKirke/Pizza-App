//
//  ContentViewModel.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 24.06.2023.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    private var requestData: RequestData = RequestData()
    private var fileManagers: FileManagers = FileManagers()
    private var jsonManagers: DecodeJson = DecodeJson()
    
    @Published var isLoad: Bool = false
    
    @Published var isUserDefault: Bool = false
    
    @Published var backInMenu: Bool = false
    
    @Published var itemNenu: CustomTabBar = CustomTabBar.menu
    
    @Published var categoryAndMealList: [CategoryForList] = []
    
    
    init() {
        getCategories()
    }
    
    private func getCategories() {
        let modelCategoties: Categories = Categories(categories: [])
        
        self.getData(url: URLs.catigories.url, model: modelCategoties) { [weak self] data, error in
            guard let self = self else {
                return
            }
            if error != "" {
                self.errorView(error)
            }
            guard let currentData = data else {
                return
            }
            self.parseJSON(data: currentData, model: modelCategoties) { [weak self]  json, error in
                guard let self = self else {
                    return
                }
                if error != "" {
                    self.errorView(error)
                }
                guard let currentJSON = json else {
                    return
                }
                if !currentJSON.categories.isEmpty {
                    self.addMealsToCategories(currentJSON) { categoties in
                        print(categoties)
                    }
                }
            }
        }
    }
    
    //
    //            getMeals {
    //                self.getDiscriptionMeal() {
    //                    self.isLoad = true
    //                    //self.saveImage()
    //                }
    //            }
    
    
    
    private func addMealsToCategories(_ listCategoryes: Categories, returnMeals: @escaping ([CategoryForList]) -> Void) {
        
        // var tempCategoris: [CategoryForList] = []
        
        for (_, category) in listCategoryes.categories.enumerated() {
            self.assamblyMeals(category.strCategory) { meals in
                let currentCategory = CategoryForList(categoryName: category.strCategory,
                                                      listMeals: meals)
                //currentCategory.listMeals = meals
                print(currentCategory)
            }
            //tempCategoris.append(currentCategory)
            break
        }
        
    }
    
    
    private func assamblyMeals(_ categoryName: String, returnMeals: @escaping ([ListMeal]) -> Void) {
        var currentMeals: [ListMeal] = []
        self.getMeals(url: URLs.category(categoryName).url) { [weak self] meals in
            guard let self = self else {
                return
            }
            if !meals.meals.isEmpty {
                for (_, meal) in meals.meals.enumerated() {
                    self.getDescription(url: meal.strMeal) { description in
                        print("Meal name - \(meal.strMeal)")
                        print(description)
//                        let currentMeal: ListMeal = ListMeal(categoryName: categoryName,
//                                                             mealName: meal.strMeal,
//                                                             imageUrl: meal.strMealThumb,
//                                                             imageData: Data(),
//                                                             description: description)
//                        currentMeals.append(currentMeal)
                    }
                }
                //returnMeals(currentMeals)
            }
        }
    }

    
    private func getMeals(url: String, returnMeals: @escaping (Meals) -> Void) {
        let modelMeals: Meals = Meals(meals: [])
        self.getData(url: url, model: modelMeals) { [weak self] data, error in
            guard let self = self else {
                return
            }
            if error != "" {
                self.errorView(error)
            }
            guard let currentData = data else {
                return
            }
            self.parseJSON(data: currentData, model: modelMeals) { [weak self] json, error in
                guard let self = self else {
                    return
                }
                if error != "" {
                    self.errorView(error)
                }
                guard let currentJSON = json else {
                    return
                }
                returnMeals(currentJSON)
            }
        }
    }
    
    private func getDescription(url: String, returnDescription: @escaping (String) -> Void) {
        let modelMealDescription: MealDescription = MealDescription(meals: [["" : ""]])
        let assamblyUrl = URLs.meal(url).url.replace()
        var descriptions: String = ""
        self.getData(url: assamblyUrl, model: modelMealDescription) { [weak self] data, error in
            guard let self = self else {
                return
            }
            if error != "" {
                self.errorView(error)
            }
            guard let currentData = data else {
                return
            }
            self.parseJSON(data: currentData, model: modelMealDescription) { [weak self]  json, error in
                guard let self = self else {
                    return
                }
                if error != "" {
                    self.errorView(error)
                }
                guard let currentJSON = json?.meals.first else {
                    return
                }
                for i in 1...20 {
                    let assablyKey = "strIngredient\(i)"
                    self.enumirateKey(currentKey: assablyKey, array: currentJSON) { (isSearch, name) in
                        if name != "" {
                            if i == 1 {
                                descriptions += name + "."
                            } else {
                                descriptions += " " + name + "."
                            }
                        }
                    }
                }
                returnDescription(descriptions)
            }
        }
    }
    
    private func enumirateKey(currentKey: String, array: [String : String?], returnKey: (Bool, String) -> Void) {
        for (_, elem) in array.enumerated() {
            if elem.key == currentKey {
                guard let nameKey = elem.value else {
                    return returnKey(false, "")
                }
                return returnKey(true, "\(nameKey.capitalizingFirstLetter())")
            }
        }
    }
    
    private func getImage(url: String, returnImage: @escaping (String) -> Void) {
        
    }
    
    //    private func saveImage() {
    //        if !categoryAndMealList.isEmpty {
    //            for (index, _) in self.categoryAndMealList.enumerated() {
    //                for (ind, meal) in self.categoryAndMealList[index].listMeals.enumerated() {
    //                    self.requestData.getImage(url: meal.imageUrl) { data in
    //                        guard let currentData = data else {
    //                            return
    //                        }
    //                        DispatchQueue.main.async {
    //                            self.categoryAndMealList[index].listMeals[ind].imageData = currentData
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    
    //    private func getDiscriptionMeal(result: @escaping () -> Void) {
    //        if !categoryAndMealList.isEmpty {
    //            for (index, _) in self.categoryAndMealList.enumerated() {
    //                for (int, meal) in self.categoryAndMealList[index].listMeals.enumerated() {
    //                    var descriptions: String = ""
    //                    let assamblyUrl = URLs.meal(meal.mealName).url.replace()
    //                    self.requestData.getData(url: assamblyUrl, model: modelMealDescription) { [weak self] data, error in
    //                        if error != "" {
    //                            print("errors \(String(describing: error))")
    //                        }
    
    //                        guard let currentData = data?.meals.first else {
    //                            return
    //                        }
    //
    //                        guard let self = self else {
    //                            return
    //                        }
    //                        for i in 1...20 {
    //                            let assablyKey = "strIngredient\(i)"
    //                            self.enumirateKey(currentKey: assablyKey, array: currentData) { (isSearch, name) in
    //                                guard let currentName = name else {
    //                                    return
    //                                }
    //                                if currentName != "" {
    //                                    if i == 1 {
    //                                        descriptions += currentName + "."
    //                                    } else {
    //                                        descriptions += " " + currentName + "."
    //                                    }
    //                                }
    //                            }
    //                        }
    //                        self.categoryAndMealList[index].listMeals[int].description = descriptions
    //                    }
    //                }
    //            }
    //            return result()
    //        }
    //    }
    
    
    
    
    private func getData<T: Decodable>(url: String, model: T, returnData: @escaping (Data?, String) -> Void ) {
        self.requestData.getData(url: url) { [weak self] data, error in
            guard let self = self else {
                return
            }
            if error != "" {
                self.errorView(error)
            }
            guard let currentData = data else {
                return
            }
            returnData(currentData, "")
        }
    }
    
    
    private func parseJSON<T: Decodable>(data: Data, model: T, returnJSON: @escaping (T?, String) -> Void ) {
        self.jsonManagers.decodeJSON(data: data, model: model) { json, error in
            if error != "" {
                self.errorView(error)
            }
            guard let currentJSON = json else {
                return
            }
            returnJSON(currentJSON, "")
        }
    }
    
    
    func saveFileManager() {
        self.jsonManagers.encodeJSON(models: categoryAndMealList) { [weak self] data, error in
            guard let self = self else {
                return
            }
            if error != "" {
                self.errorView(error)
            }
            guard let currentData = data else {
                return
            }
            self.fileManagers.saveToDocument(data: currentData) { status in
                self.errorView(status)
            }
        }
    }
    
    func retrieveFileManager() {
        self.fileManagers.retrieveDataFromFile { [weak self]  data, error in
            guard let self = self else {
                return
            }
            if error != "" {
                errorView(error)
            }
            guard let currentData = data else {
                return
            }
            self.jsonManagers.decodeJSON(data: currentData, model: categoryAndMealList) { json, error in
                if error != "" {
                    self.errorView(error)
                }
                guard let currentJSON = json else {
                    return
                }
                print(currentJSON)
            }
        }
    }
    
    private func errorView(_ mistake: String) {
        // show error view
        print(mistake)
    }
}


