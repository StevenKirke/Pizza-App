//
//  UserDefaults.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 26.06.2023.
//

import Foundation


class WorkUserDefaults {
    
    func saveUserDefault<T: Encodable>(currentData: T) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(currentData) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "currentCategories")
        }
    }
    
    func writeUserDefault<T: Decodable>(model: T) -> T? {
        if let currentData = UserDefaults.standard.object(forKey: "currentCategories") as? Data {
            let decoder = JSONDecoder()
            if let json = try? decoder.decode(T.self, from: currentData) {
                return json
            }
        }
        return nil
    }
    
    func removeUserDefault() {
        UserDefaults.standard.removeObject(forKey: "currentCategories")
    }
    

}
