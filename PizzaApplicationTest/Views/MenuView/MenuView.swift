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
    
    @State var currentIndex: String = "0"
    
    @State var isShow: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(contenVM: contenVM,
                       currentIndex: $currentIndex,
                       isShow: $isShow)
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: 0) {
                        if contenVM.isMeals && contenVM.isDescriptions {
                            ForEach(contenVM.categoryAndMealList.indices, id: \.self) { index in
                                let meal = contenVM.categoryAndMealList[index]
                                CardDiscriptions(currentIndex: $currentIndex,
                                                 isShow: $isShow,
                                                 index: String(index),
                                                 nameCategory: meal.categoryName,
                                                 categories: meal.listMeals)
                            }
                        } else {
                            ForEach(0...4, id: \.self) { _ in
                                CardDiscriptionsSceleton()
                            }
                        }
                    }
                    .onChange(of: currentIndex) { _ in
                        withAnimation(anim()) {
                            proxy.scrollTo(currentIndex.replacingOccurrences(of: " TAP", with: ""), anchor: .topTrailing)
                        }
                    }
                }
                .background(Color.c_F3F5F9)
                .mask(RoundedRectangle(cornerRadius: 21.0))
            }
            .coordinateSpace(name: "SCROLL")
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
                    .foregroundColor(isShow ? .c_1C222B : .red)
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
                        if !contenVM.isCategories {
                            ForEach(0...5, id: \.self) { _ in
                                ButtonForMenuSceleton()
                            }
                        } else {
                            ForEach(contenVM.categoryAndMealList.indices, id: \.self) { ind in
                                let name = contenVM.categoryAndMealList[ind].categoryName
                                ButtonForHeader(currentIndex: $currentIndex,
                                                proxy: proxy,
                                                index: String(ind),
                                                name: name)
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
}

struct ButtonForHeader: View {
    
    @Binding var currentIndex: String
    
    var proxy: ScrollViewProxy
    let index: String
    let name: String
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.currentIndex = "\(index) TAP"
                proxy.scrollTo(currentIndex.replacingOccurrences(of: " TAP", with: ""), anchor: .leading)
            }
        }) {
            Text(name)
                .customFont(13)
                .foregroundColor(anser(index) ? .c_FD3A69 : .c_FD3A69_4)
                .font(anser(index) ? Font.footnote.weight(.bold) : Font.footnote.weight(.regular))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .id(index)
        .background(
            ZStack {
                if anser(index) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.c_FD3A69_2)
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.c_FD3A69_4, lineWidth: 1)
                }
            }
        )
    }
    
    private func anser(_ index: String) -> Bool {
        if currentIndex.replacingOccurrences(of: " SCROLL", with: "") == String(index) {
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

