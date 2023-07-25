//
//  ObservableScrollView.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 24.06.2023.
//

import SwiftUI


struct ObservableScrollView<Content>: View where Content : View {
    @Namespace var scrollSpace
    
    @Binding var scrollOffset: CGFloat
    @Binding var currentIndex: Int
    let content: (ScrollViewProxy) -> Content
    
    init(scrollOffset: Binding<CGFloat>,
         currentIndex: Binding<Int>,
         @ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
        _scrollOffset = scrollOffset
        _currentIndex = currentIndex
        self.content = content
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                content(proxy)
                    .background(GeometryReader { geo in
                        let offset = -geo.frame(in: .named(scrollSpace)).minY
                        Color.clear
                            .preference(key: ScrollViewOffsetPreferenceKey.self,
                                        value: offset)
                    })
            }
        }
        .coordinateSpace(name: scrollSpace)
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }

    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
