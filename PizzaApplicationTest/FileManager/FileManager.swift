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
    
    
    func saveToDocument(name: String, data: Data, returnStatus: (String) -> Void) {
        do {
            let fileURL = filePath.appendingPathComponent(name + ".json")
            try data.write(to: fileURL)
            returnStatus("Correct")
        } catch {
            returnStatus("Error save document.")
        }
    }
    
    
    func retrieveDataFromFile(name: String, returnStatus: (Data?, Bool, String) -> Void) {
        let fileURL = filePath.appendingPathComponent(name + ".json")
        do {
            let data = try Data(contentsOf: fileURL)
            returnStatus(data, true, "Yes Data")
        } catch {
            returnStatus(nil, false, "No data.")
        }
    }
    
    
    func removeDocument(name: String, returnStatus: (String) -> Void) {
        let fileURL = filePath.appendingPathComponent(name + ".json")
        do {
            try FileManager.default.removeItem(at: fileURL)
            returnStatus("Delete")
        } catch  {
            returnStatus("Error remove file.")
        }
    }
}
