//
//  OffsetsModefier.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 26.06.2023.
//

import SwiftUI


struct OffsetsModefier: ViewModifier {
    
    @Binding var isShow: Bool
    @Binding var currentIndex: String
    let index: String
    
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
                    currentIndex = (offset < 20 && -offset < (proxy.midX) && currentIndex != index)  ? "\(index) SCROLL" : currentIndex
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
