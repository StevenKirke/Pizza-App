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
    @State var currentIndex: String = "0"
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(contenVM: contenVM, currentIndex: $currentIndex, isShow: $isShow)
            ObservableScrollView(scrollOffset: $scrollOffset, currentIndex: $currentIndex) { proxy in
                if contenVM.isLoad {
                    VStack(spacing: 0) {
                        ForEach(contenVM.categoryAndMealList.indices, id: \.self) { indexCategory in
                            CardDiscriptions(currentIndex: $currentIndex, index: String(indexCategory),
                                             nameCategory: contenVM.categoryAndMealList[indexCategory].categoryName,
                                             categories: contenVM.categoryAndMealList[indexCategory].listMeals)
                            .onChange(of: scrollOffset) { newValue in
                                withAnimation(anim()) {
                                    if scrollOffset <= -50 {
                                        self.isShow = true
                                    } else if scrollOffset >= 100 {
                                        self.isShow = false
                                    }
                                }
                            }
                            .onChange(of: currentIndex) { newValue in
                                withAnimation(.easeInOut) {
                                    proxy.scrollTo(newValue.replacingOccurrences(of: " TAP", with: ""), anchor: .topTrailing)
                                }
                            }
                        }
                    }
                } else {
                    ForEach(0...4, id: \.self) { _ in
                        CardDiscriptionsSceleton()
                    }
                }
            }
            .coordinateSpace(name:  "SCROLL")
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
    
    
    @Binding var currentIndex: String
    @Binding var isShow: Bool
    
    
    var title: String = "Moskow"
    
    var body: some View {
        VStack(spacing: 28) {
            HStack(spacing: 8) {
                Text(title)
                    .customFont(17)
                    .foregroundColor(.c_1C222B)
                    .font(Font.footnote.weight(.medium))
                Button(action: {
                }) {
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
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        if !contenVM.isLoad {
                            ForEach(0...4, id: \.self) { _ in
                                ButtonForMenuSceleton()
                            }
                        } else {
                            ForEach(contenVM.categoryAndMealList.indices, id: \.self) { index in
                                let name = contenVM.categoryAndMealList[index].categoryName
                                Button(action: {
                                    self.currentIndex = "\(index) TAP"
                                    proxy.scrollTo(currentIndex.replacingOccurrences(of: " TAP", with: ""), anchor: .leading)
                                }) {
                                    Text(name)
                                        .customFont(13)
                                        .foregroundColor(anser(String(index)) ? .c_FD3A69 : .c_FD3A69_4)
                                        .font(anser(String(index)) ? Font.footnote.weight(.bold) : Font.footnote.weight(.regular))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .id(index)
                                .background(
                                    ZStack {
                                        if anser(String(index)) {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.c_FD3A69_2)
                                        } else {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.c_FD3A69_4, lineWidth: 1)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.vertical, 1)
                    .padding(.horizontal, 18)
                }
                .onChange(of: currentIndex, perform: { _ in
                    if currentIndex.contains(" SCROLL") {
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(currentIndex.replacingOccurrences(of: " SCROLL", with: ""), anchor: .topTrailing)
                        }
                    }
                })
            }
        }
        .padding(.bottom, 10)
    }
    
    
     func anser(_ index: String) -> Bool {
        if currentIndex.replacingOccurrences(of: " TAP", with: "") == index
            || currentIndex.replacingOccurrences(of: " SCROLL", with: "") == index {
            return true
        }
        return false
    }
}



#if DEBUG
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(globalModel: GlobalModel(), contenVM: ContentViewModel())
    }
}
#endif

