//
//  CustomTabBar.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 23.06.2023.
//

import Foundation
import SwiftUI


enum CustomTabBar: Int, CaseIterable {
    case menu
    case contact
    case profile
    case basked
}

extension CustomTabBar {
    
    var title: String {
        switch self {
        case .menu:
                return "Меню"
        case .contact:
                return "Контакты"
        case .profile:
                return "Профиль"
        case .basked:
                return "Корзина"
        }
    }
    
    var image: Image {
        switch self {
        case .menu:
                return .menu
        case .contact:
                return .contact
        case .profile:
                return .profile
        case .basked:
                return .basket
        }
    }
}
