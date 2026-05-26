//
//  RootView.swift
//  quickfood
//
//  Created by Bintang Marsyuma Rakhasunu on 24/05/26.
//


import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            SplashScreenView()
        } else {
            WelcomeView()
        }
    }
}
