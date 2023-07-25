//
//  DecodeJson.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 25.06.2023.
//

import Foundation

class DecodeJson {
    
    func decodeJSON<T: Decodable>(data: Data, model: T, returnJSON: @escaping (T?, String) -> Void)  {
        DispatchQueue.main.async {
            do {
                let decodedUsers = try JSONDecoder().decode(T.self, from: data)
                return returnJSON(decodedUsers, "")
            } catch {
                return returnJSON(nil, "Error decode JSON.")
            }
        }
    }
    
    
    func encodeJSON<T: Encodable>(models: T, returnData: @escaping (Data?, String) -> Void) {
        DispatchQueue.main.async {
            do {
                let data = try JSONEncoder().encode(models)
                return returnData(data, "")
            } catch {
                return returnData(nil, "Error decode in data.")
            }
        }
    }
    
    
    func decodeJPEG(data: Data, returnData: @escaping (Data?, String) -> Void)  {
        DispatchQueue.main.async {
            do {
                let encoded = try PropertyListEncoder().encode(data)
                return returnData(encoded, "")
            } catch {
                return returnData(nil, "Error decode JPEG.")
            }
        }
    }
}

