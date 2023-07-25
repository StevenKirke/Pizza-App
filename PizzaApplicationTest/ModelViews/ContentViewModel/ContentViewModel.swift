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
    
    @Published var isCategories: Bool = false
    @Published var isMeals: Bool = false
    @Published var isDescriptions: Bool = false
    @Published var isImages: Bool = false
    @Published var isFile: Bool = false
    
    @Published var backInMenu: Bool = false
    @Published var itemNenu: CustomTabBar = CustomTabBar.menu
    
    @Published var categoryAndMealList: [CategoryForList] = []
    
    let nameFile: String = "meals"
    
    init() {
        self.fileSearch()
    }
    
    
    private func getCategories() {
        let modelCategoties: Categories = Categories(categories: [])
        let group = DispatchGroup()
        
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
            self.parseJSON(data: currentData, model: modelCategoties) { [weak self] json, error in
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
                    for (_, category) in currentJSON.categories.enumerated() {
                        group.enter()
                        self.categoryAndMealList.append(CategoryForList(categoryName: category.strCategory,
                                                                        listMeals: []))
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    self.isCategories = true
                    print("All get category.")
                    self.enumerationMeals() { responseMeals in
                        print(responseMeals)
                        self.enumerationDescription() { responseDescriptions in
                            print(responseDescriptions)
                            DispatchQueue.main.async {
                                self.getImage() { responseImage in
                                    print(responseImage)
                                    self.isLoad = true
                                    print("Load all data")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func enumerationMeals(returnResponse: @escaping (String) -> Void) {
        let group = DispatchGroup()
        if !self.categoryAndMealList.isEmpty {
            for (indexCategory, category) in self.categoryAndMealList.enumerated() {
                group.enter()
                self.getMeals(categoryName: category.categoryName) { meals in
                    self.categoryAndMealList[indexCategory].listMeals = meals
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.isMeals = true
                returnResponse("All get meals.")
            }
        }
    }
    
    private func getMeals(categoryName: String, returnMeals: @escaping ([ListMeal]) -> Void) {
        let modelMeals: Meals = Meals(meals: [])
        var currentMeals: [ListMeal] = []
        var countMeals: Int = 0
        self.getData(url: URLs.category(categoryName).url, model: modelMeals) { [weak self] data, error in
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
                if !currentJSON.meals.isEmpty {
                    for (_, meal) in currentJSON.meals.enumerated() {
                        countMeals += 1
                        currentMeals.append(ListMeal(categoryName: categoryName,
                                                     mealName: meal.strMeal,
                                                     imageUrl: meal.strMealThumb,
                                                     imageData: Data(),
                                                     description: ""))
                        if countMeals == 3 {
                            break
                        }
                    }
                }
                returnMeals(currentMeals)
            }
        }
    }
    
    private func enumerationDescription(returnResponse: @escaping (String) -> Void) {
        let group = DispatchGroup()
        for (indexCategory, category) in self.categoryAndMealList.enumerated() {
            for (indexMeal, meal) in category.listMeals.enumerated() {
                group.enter()
                self.getDescription(meal.mealName) { [weak self] description in
                    guard let self = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.categoryAndMealList[indexCategory].listMeals[indexMeal].description = description
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            self.isDescriptions = true
            returnResponse("All get description.")
        }
    }
    
    private func getDescription(_ mealName: String, returnDescription: @escaping (String) -> Void) {
        let modelMealDescription: MealDescription = MealDescription(meals: [["" : ""]])
        let assamblyUrl = URLs.meal(mealName).url.replace()
        var descriptions: String = ""
        self.getData(url: assamblyUrl, model: modelMealDescription) { [weak self] data, error in
            guard let self = self else {
                return
            }
            if error != "" {
                returnDescription("")
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
                    returnDescription("")
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

     
    private func getImage(returnImage: @escaping (String) -> Void) {
        
        let group = DispatchGroup()
        
        for (indexCategory, _) in self.categoryAndMealList.enumerated() {
            for (indexMeal, meal) in self.categoryAndMealList[indexCategory].listMeals.enumerated() {
                group.enter()
                self.requestData.getImage(url: meal.imageUrl) { [weak self] data, error in
                    guard let self = self else {
                        return
                    }
                    if error != "" {
                        self.errorView(error)
                    }
                    guard let currentData = data else {
                        return
                    }
                    group.leave()
                    DispatchQueue.main.async {
                        self.categoryAndMealList[indexCategory].listMeals[indexMeal].imageData = currentData
                    }

                }

            }
        }
        group.notify(queue: .main) {
            self.isImages = true
            returnImage("All get image.")
        }
    }
    
    
    private func getData<T: Decodable>(url: String, model: T, returnData: @escaping (Data?, String) -> Void ) {
        self.requestData.getData(url: url) { data, error in
            returnData(data, error)
        }
    }
    
    
    private func parseJSON<T: Decodable>(data: Data, model: T, returnJSON: @escaping (T?, String) -> Void ) {
        self.jsonManagers.decodeJSON(data: data, model: model) { json, error in
            returnJSON(json, error)
        }
    }
    
    
    func saveFileManager() {
        self.jsonManagers.encodeJSON(models: categoryAndMealList) { [weak self] data, error in
            guard let self = self else {
                return
            }
            if error != "" {
                //self.errorView(error)
            }
            guard let currentData = data else {
                return
            }
            self.fileManagers.saveToDocument(name: nameFile, data: currentData) { status in
                self.errorView(status)
            }
        }
    }
    
    func retrieveFileManager(data: Data) {
        self.jsonManagers.decodeJSON(data: data, model: categoryAndMealList) { [weak self] json, error in
            guard let self = self else {
                return
            }
            if error != "" {
                //self.errorView(error)
            }
            guard let currentJSON = json else {
                return
            }
            self.categoryAndMealList = currentJSON
        }
    }
    
    func fileSearch() {
        self.fileManagers.retrieveDataFromFile(name: nameFile) { [weak self]  data, isData, error in
            guard let self = self else {
                return
            }
            if error != "" {
                print(error)
            }
            if isData {
                guard let currentData = data else {
                    return
                }
                self.retrieveFileManager(data: currentData)
            } else {
                self.getCategories()
            }
        }
    }
    
    func deleteFile() {
        self.fileManagers.removeDocument(name: nameFile) { status in
            print(status)
        }
    }
    
    private func errorView(_ mistake: String) {
        // show error view
       // print(mistake)
    }
}

