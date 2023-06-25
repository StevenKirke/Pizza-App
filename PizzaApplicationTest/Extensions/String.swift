//
//  String.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 25.06.2023.
//

import Foundation


extension String {
    func trim() -> String {
        self.trimmingCharacters(in: NSCharacterSet.whitespaces)
   }
    
    func replace() -> String {
        self.replacingOccurrences(of: " ", with: "%20")
    }
}
