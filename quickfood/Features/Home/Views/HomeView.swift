//
//  HomeView.swift
//  quickfood
//
//  Created by Muhammad Ridwan Novriansyah on 22/05/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 16) {
            HStack{
                Circle()
                    .fill(Color.red)
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text("Morning, Marwani!")
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
        }
        .task {
            viewModel.loadHealthDataIfNeeded()
        }
    }
}

#Preview {
    HomeView()
}
