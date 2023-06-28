//
//  TestScrollViews.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 27.06.2023.
//

import SwiftUI

struct TestScrollViews: View {
    
    @StateObject  var globalModel: GlobalModel
    @ObservedObject var contenVM: ContentViewModel = ContentViewModel()
    
    
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { horizontal in
                        HStack(spacing: 10) {
                            ForEach(0...5, id: \.self) { index in
                                TestHeader( currentIndex: $currentIndex, name: "Name \(index)", index: index)
                                    .onChange(of: currentIndex) { newValue in
                                        withAnimation(.easeInOut) {
                                            horizontal.scrollTo(currentIndex, anchor: .topTrailing)
                                        }
                                    }
                                    
                            }
                            .coordinateSpace(name: "SCROLL BUTTON")
                            Spacer()
                        }
                        .padding(.leading, 15)
                    }
                }
                .padding(.bottom, 10)
                .background(Color.c_F3F5F9)
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { vertical in
                        VStack(spacing: 0) {
                            ForEach(0...5, id: \.self) { index in
                                TestCardDescription(currentIndex: $currentIndex, categoryName: "Category name \(index)", index: index)
                                    .onChange(of: currentIndex) { newValue in
                                        withAnimation(.easeInOut) {
                                            vertical.scrollTo(currentIndex, anchor: .topTrailing)
                                        }
                                    }
                            }
                        }
                        .coordinateSpace(name: "SCROLL VIEW")
                    }
                }
                .mask(
                    RoundedRectangle(cornerRadius: 12)
                )
            }
            .onAppear {
                self.globalModel.safeArea = (proxy.safeAreaInsets.top, proxy.safeAreaInsets.bottom)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct TestOffsetsModefier: ViewModifier {
    
    @State var offset: CGFloat = .zero
    @Binding var currentIndex: Int
    
    let index: Int
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.red.opacity(0.4)
                        .preference(key: TestOffsetKey.self, value: proxy.frame(in: .named("SCROLL BUTTON")))
                }
            )
            .onPreferenceChange(TestOffsetKey.self) { proxy in
                withAnimation(.easeInOut) {
                    let offset = proxy.minY
                    print("offset BUTTON - \(offset)")
                    currentIndex = (offset < 20 && -offset < (proxy.minX / 2) && currentIndex != index ?  index/*"\(label) SCROLL"*/ : currentIndex)
                }
            }
    }
}

struct TestOffsetsButtonModefier: ViewModifier {
    
    @State var offset: CGFloat = .zero
    @Binding var currentIndex: Int
    
    let index: Int
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.red.opacity(0.4)
                        .preference(key: TestOffsetKey.self, value: proxy.frame(in: .named("SCROLL VIEW")))
                }
            )
            .onPreferenceChange(TestOffsetKey.self) { proxy in
                withAnimation(.easeInOut) {
                    let offset = proxy.minY
                    print("offset VIEW - \(offset)")
                    currentIndex = (offset < 20 && -offset < (proxy.minY / 2) && currentIndex != index ? index/*"\(label) SCROLL"*/ : currentIndex)
                }
            }
    }
}

struct TestOffsetKey: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


struct TestCardDescription: View {
    
    @Binding var currentIndex: Int
    
    let categoryName: String
    let index: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Text(categoryName)
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
            ForEach(0...8, id: \.self) { list in
                HStack(spacing: 20) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 60, weight: .bold))
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Name")
                            .font(.system(size: 16, weight: .regular))
                        Text("We cant sign you in with this credential because your domain inst available.")
                            .font(.system(size: 16, weight: .regular))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.c_C3C4C9)
                )
            }
            .padding(.bottom, 2)
        }
        .padding(.horizontal, 10)
        .modifier(TestOffsetsModefier(currentIndex: $currentIndex, index: index))
        .id("\(index)")
    }
}


struct TestHeader: View {
    
    @Binding var currentIndex: Int
    
    let name: String
    let index: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        self.currentIndex = index
                    }
                }
            }) {
                HStack(spacing: 0) {
                    Text(name)
                        .font(.system(size: 15, weight: index == currentIndex ? .bold : .regular))
                        .foregroundColor(Color.c_FD3A69)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(
                    ZStack {
                        if index == currentIndex {
                            Capsule()
                                .fill(Color.c_FD3A69_2)
                        } else {
                            Capsule()
                                .stroke(Color.c_FD3A69, lineWidth: 1)
                        }
                    }
                )
            }
            Capsule()
                .fill(index == currentIndex ? Color.c_FD3A69 : Color.c_FD3A69_2)
                .frame(maxWidth: .infinity, maxHeight: 4)
        }
        .padding(.top, 10)
        .padding(.vertical, 1)
        .id("\(index)")
    }
}





#if DEBUG
struct TestScrollViews_Previews: PreviewProvider {
    static var previews: some View {
        TestScrollViews(globalModel: GlobalModel())
    }
}
#endif
