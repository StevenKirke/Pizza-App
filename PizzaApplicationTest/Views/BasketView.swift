//
//  BasketView.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 24.06.2023.
//

import SwiftUI

struct BasketView: View {
    var body: some View {
        ZStack {
            Color.white
            Text("Backet view")
                .customFont(17)
                .foregroundColor(.c_222831)
                .font(Font.footnote.weight(.bold))
        }
    }
}

#if DEBUG
struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView()
    }
}
#endif
