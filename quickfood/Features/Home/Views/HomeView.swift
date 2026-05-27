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
    @State private var editName: Bool = false
    @State private var newName: String = ""
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { timeline in
            let displayName = viewModel.displayName(from: userName)
            let greeting = viewModel.greeting(for: timeline.date)
            let selectedAllergies = viewModel.selectedAllergies(from: selectedAllergyRawValues)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                if viewModel.isEditingName {
                                    TextField("Enter Name", text: $viewModel.editedName)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .textFieldStyle(.plain)
                                        .submitLabel(.done)
                                        .focused($isNameFieldFocused)
                                        .onSubmit {
                                            userName = viewModel.saveEditedName(currentName: userName)
                                            isNameFieldFocused = false
                                        }
                                        .onAppear {
                                            isNameFieldFocused = true
                                        }
                                } else {
                                    Text("\(greeting), \(displayName)!")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Button {
                                        viewModel.startEditingName(currentName: userName)
                                    } label: {
                                        Image(systemName: "pencil.line")
                                            .font(.title3.weight(.semibold))
                                            .foregroundStyle(Color.primary)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            Text(timeline.date, style: .date)
                                .font(.subheadline)
                                .fontWeight(.light)
                        }
                        
                        Spacer()

                        Image("OnboardingMan")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                            }
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
