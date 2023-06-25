//
//  Color.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 23.06.2023.
//

import SwiftUI

extension Color {
    enum Name: String {
        case C_222831
        case C_AAAAAD
        case C_C3C4C9
        case C_E5E5E5
        case С_1C222B
        case С_F3F5F9
        case C_FD3A69
        case C_FD3A69_4
        case C_FD3A69_2
    }
}

extension Color.Name {
    var path: String {
        "Colors/\(rawValue)"
    }
}

extension Color {
    init(_ name: Color.Name) {
        self.init(name.path)
    }
    
    static let c_222831 = Color(Name.C_222831)
    static let c_AAAAAD = Color(Name.C_AAAAAD)
    static let c_C3C4C9 = Color(Name.C_C3C4C9)
    static let c_E5E5E5 = Color(Name.C_E5E5E5)
    static let c_1C222B = Color(Name.С_1C222B)
    static let c_F3F5F9 = Color(Name.С_F3F5F9)
    static let c_FD3A69 = Color(Name.C_FD3A69)
    static let c_FD3A69_4 = Color(Name.C_FD3A69_4)
    static let c_FD3A69_2 = Color(Name.C_FD3A69_2)
}
