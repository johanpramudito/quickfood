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
    @AppStorage("selectedAllergies") private var selectedAllergyRawValues = ""
    
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { timeline in
            let displayName = viewModel.displayName(from: userName)
            let greeting = viewModel.greeting(for: timeline.date)
            let selectedAllergies = viewModel.selectedAllergies(from: selectedAllergyRawValues)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(greeting), \(displayName)!")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(timeline.date, style: .date)
                                .font(.subheadline)
                                .fontWeight(.light)
                        }

                        Spacer()

                        Circle()
                            .fill(Color.red)
                            .frame(width: 50, height: 50)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(greeting), \(displayName). \(timeline.date.formatted(date: .long, time: .omitted))")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    
                    PhaseCard(cycleDay: viewModel.todayCycleDay)

//                    if !selectedAllergies.isEmpty {
                        AvoidFoodsSection(allergies: selectedAllergies)
//                    }
                    
                    CardView(allergies: selectedAllergies, currentPhase: viewModel.todayCycleDay?.phases.first)
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .background(.primaryBackground)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
