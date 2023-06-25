//
//  CustomImage.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 25.06.2023.
//

import SwiftUI

struct CustomImage: View {
    
    let image: String
    
    var body: some View {
        AsyncImage(url: URL(string: image)) { phase in
            switch phase {
                case .empty:
                    ProgressView()
                        .tint(.red)
                case .success(let image):
                    image
                        .resizable()
                case .failure(_):
                    Image(systemName: "photo")
                        .resizable()
                @unknown default:
                    Image(systemName: "photo")
                        .resizable()
            }
        }

    }
}
