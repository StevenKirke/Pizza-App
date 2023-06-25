//
//  MenuView.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 24.06.2023.
//

import SwiftUI

struct MenuView: View {
    
    @StateObject  var globalModel: GlobalModel
    @ObservedObject var contenVM: ContentViewModel
    
    @State var isShow: Bool = false
    @State var scrollOffset = CGFloat.zero
    
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(contenVM: contenVM, currentLabel: $contenVM.currentLabel, isShow: $isShow)
                .coordinateSpace(name:  "SCROLL")
            ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                ScrollViewReader { proxy in
                    if contenVM.isLoad {
                        ForEach(contenVM.categoryAndMealList.indices, id: \.self) { indexCategory in
                            VStack(spacing: 0) {
                                CardDiscriptions(currentLabel: $contenVM.currentLabel,
                                                 nameCategory: contenVM.categoryAndMealList[indexCategory].categoryName,
                                                 categories: contenVM.categoryAndMealList[indexCategory].listMeals)
                                .onChange(of: scrollOffset) { newValue in
                                    DispatchQueue.main.async {
                                        if scrollOffset <= -50 {
                                            withAnimation(anim()) {
                                                self.isShow = true
                                            }
                                        } else if scrollOffset >= 100 {
                                            withAnimation(anim()) {
                                                self.isShow = false
                                            }
                                        }
                                    }
                                }
                            }
                            .onChange(of: contenVM.currentLabel) { newValue in
                                withAnimation(anim()) {
                                    proxy.scrollTo(contenVM.currentLabel, anchor: .topTrailing)
                                }
                            }
                        }
                    }
                }
            }
            .background(Color.c_F3F5F9)
            .mask(RoundedRectangle(cornerRadius: 21.0))
        }
    }
    
    private func anim() -> Animation {
        .easeInOut
    }
}



struct HeaderView: View {
    
    @ObservedObject var contenVM: ContentViewModel
    
    
    @Binding var currentLabel: String
    @Binding var isShow: Bool
    
    var title: String = "Moskow"
    
    var body: some View {
        VStack(spacing: 28) {
            HStack(spacing: 8) {
                Text(title)
                    .customFont(17)
                    .foregroundColor(.c_1C222B)
                    .font(Font.footnote.weight(.medium))
                Button(action: {}) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16))
                        .foregroundColor(.c_222831)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 18)
            if isShow {
                BannerSBlock()
                    .opacity(isShow ? 1.0 : 0.0)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack(spacing: 20) {
                        if !contenVM.isLoad {
                            Text("111111")
                                .foregroundColor(.red)
                        } else {
                            ForEach(contenVM.categoryAndMealList.indices, id: \.self) { index in
                                let name = contenVM.categoryAndMealList[index].categoryName
                                ButtonForMenu(currentLabel: $currentLabel, label: name)
                            }
                        }
                    }
                    .padding(.vertical, 1)
                    .padding(.horizontal, 18)
                }
            }
        }
        .padding(.bottom, 10)
    }
}

struct ButtonForMenu: View {
    
    @Binding var currentLabel: String
    var label: String
    
    var body: some View {
        Button(action: {
            DispatchQueue.main.async {
                withAnimation(.easeOut) {
                    self.currentLabel = label
                }
            }
        }) {
            Text(label)
                .customFont(13)
                .foregroundColor(label == currentLabel.replacingOccurrences(of: " SCROLL", with: "") ? .c_FD3A69 : .c_FD3A69_4)
                .font(label == currentLabel ? Font.footnote.weight(.bold) : Font.footnote.weight(.regular))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            ZStack {
                if label == currentLabel.replacingOccurrences(of: " SCROLL", with: "") {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.c_FD3A69_2)
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.c_FD3A69_4, lineWidth: 1)
                }
            }
        )
        .id(label)
    }
}


#if DEBUG
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(globalModel: GlobalModel(), contenVM: ContentViewModel())
    }
}
#endif



struct OffsetsModefier: ViewModifier {
    
    @Binding var currentLabel: String
    var label: String
    
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
                    currentLabel = (offset < 20 && -offset < (proxy.minX / 2) && currentLabel != label ? "\(label) SCROLL" : currentLabel)
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
