//
//  ProfileView.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 24.06.2023.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color.white
            Text("Profile view")
                .customFont(17)
                .foregroundColor(.c_222831)
                .font(Font.footnote.weight(.bold))
        }
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
#endif
