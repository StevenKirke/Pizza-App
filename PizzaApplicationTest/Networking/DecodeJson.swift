//
//  DecodeJson.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 25.06.2023.
//

import Foundation

class DecodeJson {
    
    func JSONDecode<T: Decodable>(data: Data, model: T, returnJSON: @escaping (T?, String?) -> Void)  {
        DispatchQueue.main.async {
            do {
                let decodedUsers = try JSONDecoder().decode(T.self, from: data)
                return returnJSON(decodedUsers, "")
            } catch let error {
                print("error JSON --- \(error.localizedDescription)")
                return returnJSON(nil, "Error decode JSON \(error)")
            }
        }
    }
    
    func JpegDecode(data: Data, returnData: @escaping (Data?, String?) -> Void)  {
        DispatchQueue.main.async {
            do {
                let encoded = try PropertyListEncoder().encode(data)
                return returnData(encoded, "")
            } catch let error {
                print("error JPEG --- \(error)")
                return returnData(nil, "Error decode JPEG \(error)")
            }
        }
    }
}

