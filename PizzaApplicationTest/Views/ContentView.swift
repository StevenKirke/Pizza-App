//
//  ContentView.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 23.06.2023.
//

import SwiftUI



struct ContentView: View {
    
    @StateObject var globalModel: GlobalModel
    
    @ObservedObject var contenVM: ContentViewModel = ContentViewModel()
    
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                ContentBlock(contentVM: contenVM)
                    .padding(.bottom, 83)
                NanigationTabBar(item: $contenVM.itemNenu, isBackMenu: $contenVM.backInMenu)
            }
            .onAppear {
                self.globalModel.safeArea = (proxy.safeAreaInsets.top, proxy.safeAreaInsets.bottom)
            }
        }
        .background(Color.c_F3F5F9)
        .environmentObject(globalModel)
        .edgesIgnoringSafeArea(.bottom)
    }
}



struct ContentBlock: View {
    
    
    @ObservedObject var contentVM: ContentViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            switch contentVM.itemNenu {
                case .menu: MenuView(globalModel: GlobalModel(), contenVM: contentVM)
                case .contact: ContactView()
                case .profile: ProfileView()
                case .basked: BasketView()
            }
        }
    }
}



#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(globalModel: GlobalModel())
    }
}
#endif
