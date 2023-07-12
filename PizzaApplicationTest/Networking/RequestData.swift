//
//  RequestData.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 25.06.2023.
//

import SwiftUI

class RequestData {
    
    let task = URLSession.shared
    
    func getData(url: String, returnData: @escaping (Data?, String) -> Void) {
        guard let url = URL(string: url) else {
            returnData(nil, "Convert url.")
            return
        }
        let request = URLRequest(url: url)
        let dataTask = task.dataTask(with: request) { data, _, error in
            if error != nil {
                returnData(nil, "Request data.")
                return
            }
            guard let currentData = data else {
                returnData(nil, "Response data.")
                return
            }
            returnData(currentData, "")
        }
        dataTask.resume()
    }
    
    func getImage(url: String?, returnData: @escaping (Data?, String) -> Void) {
        guard let url = URL(string: url ?? "") else {
            print("Convert URL.")
            return
        }
        let dataTask = task.dataTask(with: url) { data, _, error in
            if error != nil {
                returnData(nil, "Request data.")
                return
            }
            guard let data = data else {
                returnData(nil, "Response data.")
                return
            }
            return returnData(data, "")
        }
        dataTask.resume()
    }
}
