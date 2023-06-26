//
//  RequestData.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 25.06.2023.
//

import SwiftUI

class RequestData {
    
    var responseData: ResponseData = ResponseData()
    var json: DecodeJson = DecodeJson()
    
    func getData<T: Decodable>(url: String, model: T, returnData: @escaping (T?, String?) -> Void) {
        guard let url = URL(string: url) else {
            print("Error convert URL")
            return
        }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            if error != nil {
                return
            }
            guard let data = data else {
                return
            }
            guard let self = self else {
                return
            }
            self.responseData.convertData(data: data, models: model) { (data, error)  in
                guard (error?.description) != nil else {
                    return returnData(nil, error)
                }
                guard let data = data else {
                    return
                }
                return returnData(data, "")
            }
        }
        dataTask.resume()
    }
    
    func getImage(url: String?, returnData: @escaping (Data?) -> Void) {
        guard let url = URL(string: url ?? "") else {
            print("Error convert URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                return
            }
            guard let data = data else {
                return
            }
            return returnData(data)
        }
        task.resume()
        
    }
}
