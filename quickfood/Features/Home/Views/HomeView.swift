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
        VStack(spacing: 8) {
            HStack{
                Circle()
                    .fill(Color.red)
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text("Morning, \(userName)!")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(Date(), style: .date)
                        .font(.subheadline)
                        .fontWeight(.light)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
            
            PhaseCard(cycleDay: viewModel.todayCycleDay)
            
            CardView()
        }
        .task {
            viewModel.loadHealthDataIfNeeded()
            
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Food.self, inMemory: true)
}
