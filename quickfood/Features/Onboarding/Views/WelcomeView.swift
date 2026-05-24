//
//  WelcomeView.swift
//  quickfood
//
//  Created by Johan on 20/05/26.
//

import SwiftUI

struct WelcomeView: View {

    @State private var navigateToEnterName = false

    @State private var showHeader = false
    @State private var showImages = false
    @State private var showButton = false

    var body: some View {
        NavigationStack{
            
            VStack {
                
                Spacer()
                
                VStack(spacing: 0) {
                    
                    Image("Logo")
                        .opacity(showHeader ? 1 : 0)
                    
                    Text("FoodCycle")
                        .font(.system(size: 64, design: .rounded))
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        .opacity(showHeader ? 1 : 0)
                    
                }
                .padding(.top, 40)
                
                Spacer()
                
                ZStack(alignment: .bottom) {
                    
                    Image("OnboardingWoman")
                        .mask(
                            LinearGradient(
                                stops: [
                                    .init(color: .white, location: 0),
                                    .init(color: .white, location: 0.25),
                                    .init(color: .clear, location: 1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: showImages ? 0 : -120)
                        .opacity(showImages ? 1 : 0)
                    
                    Image("OnboardingMan")
                        .mask(
                            LinearGradient(
                                stops: [
                                    .init(color: .white, location: 0),
                                    .init(color: .white, location: 0.25),
                                    .init(color: .clear, location: 1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .offset(x: showImages ? 0 : 120)
                        .opacity(showImages ? 1 : 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Button {
                    navigateToEnterName = true
                } label: {
                    Text("Start")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .foregroundStyle(.primaryRed)
                .glassEffect(.regular.tint(.white).interactive())
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                .opacity(showButton ? 1 : 0)
                
                
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryRed)
            .navigationDestination(isPresented: $navigateToEnterName) {
                    EnterNameView()
                }
            .onAppear {
                
                withAnimation(.easeOut(duration: 0.8)) {
                    showHeader = true
                }
                
                withAnimation(.easeOut(duration: 1).delay(0.3)) {
                    showImages = true
                }
                
                withAnimation(.easeOut(duration: 0.6).delay(1.0)) {
                    showButton = true
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
