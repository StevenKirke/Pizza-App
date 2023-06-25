//
//  ResponseData.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 25.06.2023.
//

import Foundation

class ResponseData {

    var json: DecodeJson = DecodeJson()
    
    func convertData<T: Decodable>(data: Data, models: T, returnResponse: @escaping (T?, String?) -> Void) {
        self.json.JSONDecode(data: data, model: models) { (json, error)  in
            guard let error = error else  {
                return
            }
            if error != "" {
                return returnResponse(nil, "Error decode JSON \(error)")
            }
            guard let jsonConvert = json else {
                return
            }
            return returnResponse(jsonConvert, "")
        }
    }
}
