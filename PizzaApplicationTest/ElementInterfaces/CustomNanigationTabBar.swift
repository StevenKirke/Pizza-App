//
//  NanigationTabBar.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 24.06.2023.
//

import SwiftUI



struct NanigationTabBar: View {
    
    @Binding var item: CustomTabBar
    @Binding var isBackMenu: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(CustomTabBar.allCases, id: \.self) { item in
                Button(action: {
                    if self.item != item {
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.item = item
                                self.isBackMenu.toggle()
                            }
                        }
                    }
                }) {
                    VStack(spacing: 6) {
                        item.image
                            .iconSize(.red)
                        Text(item.title)
                            .customFont(13)
                            .font(Font.footnote.weight(.regular))
                    }
                    .foregroundColor(self.item == item ? Color.c_FD3A69 : Color.c_C3C4C9)
                }
                .offset(y: -10)
                if item != CustomTabBar.allCases.last {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 34)
        .frame(height: 83)
        .background(
            Rectangle()
                .fill(Color.white)
        )
    }
}

#if DEBUG
struct CustomTabBarPreviews: PreviewProvider {
    static var previews: some View {
        NanigationTabBar(item: .constant(.menu), isBackMenu: .constant(false))
    }
}
#endif

