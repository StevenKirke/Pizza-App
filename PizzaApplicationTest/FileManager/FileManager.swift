//
//  FileManager.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 06.07.2023.
//

import UIKit
import SwiftUI

class FileManagers {
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let name = "meals.json"
    
    func saveToDocument(data: Data, returnStatus: (String) -> Void) {
        do {
            let path = filePath.appendingPathComponent(name)
            try data.write(to: path)
            returnStatus("Correct")
        } catch {
            returnStatus("Error save document.")
        }
    }
    
    func retrieveDataFromFile(returnData: (Data?, String) -> Void) {
        let fileURL = filePath.appendingPathComponent(name)
        do {
            let data = try Data(contentsOf: fileURL)
            returnData(data, "")
        } catch {
            returnData(nil, "Error retrieval data.")
        }
    }
}
