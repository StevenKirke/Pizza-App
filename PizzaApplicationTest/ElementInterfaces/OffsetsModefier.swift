//
//  OffsetsModefier.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 26.06.2023.
//

import SwiftUI


struct OffsetsModefier: ViewModifier {
    
    @Binding var currentIndex: Int
    var index: Int
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: OffsetKey.self, value: proxy.frame(in: .named("SCROLL")))
                }
            )
            .onPreferenceChange(OffsetKey.self) { proxy in
                withAnimation(.easeInOut) {
                    let offset = proxy.minY
                    currentIndex = (offset < 20 && -offset < (proxy.minX / 2) && currentIndex != index ?  index/*"\(label) SCROLL"*/ : currentIndex)
                }
                
            }
    }
}

struct OffsetKey: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
