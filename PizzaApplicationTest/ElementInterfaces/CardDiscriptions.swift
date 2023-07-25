//
//  CardDiscriptions.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 24.06.2023.
//

import SwiftUI


struct CardDiscriptions: View {
    
    @Binding var currentIndex: String
    @Binding var isShow: Bool
    let index: String
    var nameCategory: String
    var categories: [ListMeal]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(categories.indices, id: \.self) { indexMeal in
                let meal = categories[indexMeal]
                HStack(alignment: .top, spacing: 32) {
                    CustomImage(image: meal.imageUrl)
                        .scaledToFill()
                        .frame(width: 132, height: 132)
                        .mask(RoundedRectangle(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 8) {
                        Text(meal.mealName)
                            .customFont(17)
                            .foregroundColor(.c_222831)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(Font.footnote.weight(.semibold))
                        Text(meal.description)
                            .customFont(13)
                            .foregroundColor(.c_AAAAAD)
                            .font(Font.footnote.weight(.regular))
                            .lineLimit(4)
                            .truncationMode(.tail)
                        HStack(spacing: 0) {
                            Spacer()
                            Price(price: "24", action: {})
                        }
                        .padding(.top, 16)
                    }
                    .frame(width: UIScreen.main.bounds.width / 2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 182)
                .background(Color.white)
                .padding(.bottom, 2)
            }
        }
        .modifier(OffsetsModefier(isShow: $isShow, currentIndex: $currentIndex, index: index))
        .id(index)
    }
}

struct Price: View {
    
    let price: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("from $\(price)")
                .customFont(13)
                .foregroundColor(.c_FD3A69)
                .font(Font.footnote.weight(.regular))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 18)
        .foregroundColor(.c_FD3A69)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.c_FD3A69, lineWidth: 1)
        )
    }
}

#if DEBUG
struct CardDiscription_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(globalModel: GlobalModel())
    }
}
#endif
