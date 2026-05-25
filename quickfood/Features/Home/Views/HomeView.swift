//
//  HomeView.swift
//  quickfood
//
//  Created by Muhammad Ridwan Novriansyah on 22/05/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @AppStorage("userName") private var userName = ""
    
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: -5) {
            HStack(alignment: .center, spacing: 12) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Morning, \(userName)!")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(Date(), style: .date)
                        .font(.subheadline)
                        .fontWeight(.light)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            
            PhaseCard(cycleDay: viewModel.todayCycleDay)
            
            CardView(currentPhase: viewModel.todayCycleDay?.phases.first)
        }
        .background(.primaryBackground)
        .padding(.top, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .task {
            viewModel.loadHealthDataIfNeeded()
            
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Food.self, inMemory: true)
}
