//
//  BannerSBlock.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 24.06.2023.
//

import SwiftUI

struct BannerSBlock: View {
    
    let banners: [Image] = [.banner_1, Image.banner_2, Image.banner_3]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(banners.indices, id: \.self) { index in
                    banners[index]
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .mask(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal, 18)
        }
    }
}

#if DEBUG
struct BannerSBlock_Previews: PreviewProvider {
    static var previews: some View {
        BannerSBlock()
    }
}
#endif
