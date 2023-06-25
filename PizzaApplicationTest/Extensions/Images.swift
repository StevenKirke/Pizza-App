//
//  Inages.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 23.06.2023.
//

import SwiftUI


extension Image {
    
    enum TabBar: String {
        case Menu
        case Contact
        case Profile
        case Basket
    }
    
    enum MockImages: String {
        case pizzaMock
    }
    
    enum Banners: String {
        case Banner_1
        case Banner_2
        case Banner_3
    }

    init(_ name: Image.TabBar) {
        self.init(name.path)
    }
    
    init(_ name: Image.MockImages) {
        self.init(name.path)
    }
    
    init(_ name: Image.Banners) {
        self.init(name.path)
    }
    
    static let menu = Image(TabBar.Menu)
    static let contact = Image(TabBar.Contact)
    static let profile = Image(TabBar.Profile)
    static let basket = Image(TabBar.Basket)
    
    static let pizzaMock = Image(MockImages.pizzaMock)
    
    static let banner_1 = Image(Banners.Banner_1)
    static let banner_2 = Image(Banners.Banner_2)
    static let banner_3 = Image(Banners.Banner_3)

}

extension Image.TabBar {
    var path: String {
        "Images/NavigationIcons/\(rawValue)"
    }
}

extension Image.MockImages {
    var path: String {
        "Images/MockImages/\(rawValue)"
    }
}

extension Image.Banners {
    var path: String {
        "Images/MockImages/Banners/\(rawValue)"
    }
}

extension Image {
    func iconSize(_ color: Color) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            //.foregroundColor(color)
    }
}
