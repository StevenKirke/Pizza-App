//
//  ScelenonForMenuView.swift
//  PizzaApplicationTest
//
//  Created by Steven Kirke on 26.06.2023.
//

import SwiftUI

struct ButtonForMenuSceleton: View {
    
    var background: Color = .clear
    
    var color: [Color] = [
        Color.c_FD3A69_2.opacity(0.0),
        Color.c_FD3A69_2.opacity(0.06),
        Color.c_FD3A69_4.opacity(0.1),
        Color.c_FD3A69_2.opacity(0.06),
        Color.c_FD3A69_2.opacity(0.0)
    ]
    
    var body: some View {
        Sceleton(background: background, color: color, heighContainer: 31, widthContainer: 70, shape: .roundRectangle(20))
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.c_FD3A69_4, lineWidth: 1)
                
            )
    }
}

struct CardDiscriptionsSceleton: View {
    
    var background: Color = Color.c_222831.opacity(0.02)
    
    var color: [Color] = [
        Color.c_C3C4C9.opacity(0.0),
        Color.c_C3C4C9.opacity(0.06),
        Color.c_C3C4C9.opacity(0.15),
        Color.c_C3C4C9.opacity(0.06),
        Color.c_C3C4C9.opacity(0.0)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 32) {
                Sceleton(background: background, color: color, heighContainer: 132, widthContainer: 132)
                VStack(alignment: .leading, spacing: 8) {
                    Sceleton(background: background, color: color, heighContainer: 28, widthContainer: 162)
                    Sceleton(background: background, color: color, heighContainer: 40, widthContainer: 140)
                    HStack(spacing: 0) {
                        Spacer()
                        SceletonPrice()
                    }
                    .padding(.top, 16)
                }
                .frame(width: UIScreen.main.bounds.width / 2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 182)
            .background(Color.white)
            .padding(.bottom, 2)
        }
    }
}

struct SceletonPrice: View {
    
    var background: Color = .clear
    
    var color: [Color] = [
        Color.c_FD3A69_2.opacity(0.0),
        Color.c_FD3A69_2.opacity(0.03),
        Color.c_FD3A69_4.opacity(0.1),
        Color.c_FD3A69_2.opacity(0.03),
        Color.c_FD3A69_2.opacity(0.0)
    ]
    
    var body: some View {
        
        Sceleton(background: background, color: color, heighContainer: 32, widthContainer: 87)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.c_FD3A69_2, lineWidth: 1)
            )
    }
}

