//
//  SplashScreenView.swift
//  quickfood
//
//  Created by Muhammad Najmi Rahmani  on 25/05/26.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if self.isActive {
                NavigationStack {
                    HomeView()
                }
            } else {
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.primaryYellow)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
