//
//  Text.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 24.06.2023.
//

import SwiftUI

extension Text {
    func customFont(_ size: CGFloat) -> some View {
        self
            .font(Font.custom("SF UI Display.ttf", size: size))
    }
}
