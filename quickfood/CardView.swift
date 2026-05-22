//
//  CardView.swift
//  quickfood
//
//  Created by Muhammad Najmi Rahmani  on 22/05/26.
//

import SwiftUI

struct CardView: View {
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sayur Asem")
                        .foregroundStyle(Color.white)
                        .font(.title.bold())
                    
                    HStack(spacing: 8) {
                        // Nanti for each tag
                        HStack(spacing: 4) {
                            Text("#Ayam")
                                .foregroundStyle(Color.black)
                            
                        }
                        .frame(width: 102, height: 31)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(20)
                        .glassEffect()
                    }
                    
                    Divider()
                    
                    Text("Sayur asem is a traditional Indonesian vegetable soup dish with a clear or slightly cloudy broth with a fresh, savory, and slightly sweet tamarind flavor.")
                        .font(.callout)
                        .foregroundStyle(Color.white)
                }
                .padding(16)
                .padding(.top, 252)
            }
            .frame(width: 362, height: 460, alignment: .leading)
            .background(
                Image("Sayurasem")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            )
            .cornerRadius(24)
            .padding(16)
            .padding(.top, 252)
            //        .blur(radius: 0.1)
        }
        .offset(x: offset.width, y: offset.height * 0)
        .rotationEffect(.degrees(Double(offset.width / 30)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
            
                .onEnded { _ in
                    if offset.width > 150 {
                        Swiped()
                    }
                    else if offset.width < -150 {
                        Swiped()
                    }
                    else {
                        offset = .zero
                    }
                }
        )
        .animation(.spring(), value: offset)
    }
    
    func Swiped() {
        // Put to the last index
        
    }
}

#Preview {
    CardView()
}
