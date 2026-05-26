//
//  CardView.swift
//  quickfood
//
//  Created by Muhammad Najmi Rahmani  on 22/05/26.
//

import SwiftUI
import SwiftData

struct CardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Food.name) private var foodsData: [Food]
    @StateObject private var viewModel = CardStackViewModel()

    let allergies: [UserAllergy]
    
    let currentPhase: CyclePhase?  // ← add this

    var body: some View {
        VStack(alignment: .leading, spacing: -3) {
            Text("We Recommend You to Eat")
                .padding(.leading, 16)
                .font(.body.bold())

            ZStack {
                let visibleCards = Array(viewModel.visibleCards)
                ForEach(Array(visibleCards.enumerated()).reversed(), id: \.element.persistentModelID) { item in
                    FoodCard(foodsData: item.element, onSwiped: onSwiped)
                        .stacked(at: item.offset)
                        .transition(.identity)
                        .animation(.spring(response: 0.42, dampingFraction: 0.88), value: item.offset)
                        .allowsHitTesting(item.offset == 0)
                }
            }
        }
        .task {
            seedFoodsIfNeeded(modelContext: modelContext)
            loadFilteredFoods()
        }
        .onChange(of: currentPhase?.rawValue) { _, _ in  // ← reload when phase changes
            loadFilteredFoods()
        }
        .onChange(of: foodsData.count) { _, _ in
            viewModel.loadFoodsIfEmpty(filteredFoods())
        }
    }

    private func filteredFoods() -> [Food] {
        let allergyTags = Set(allergies.map { $0.rawValue })

        guard let phase = currentPhase else {
            return foodsData.filter { food in
                Set(food.tags).isDisjoint(with: allergyTags)
            }
        }

        return foodsData.filter { food in
            food.cyclePhase == phase.rawValue &&
            Set(food.tags).isDisjoint(with: allergyTags)
        }
    }

    private func loadFilteredFoods() {
        viewModel.loadFoods(filteredFoods())
    }

    private func onSwiped() {
        withAnimation(.spring(response: 0.42, dampingFraction: 0.88)) {
            viewModel.moveTopCardToBack()
        }
    }
}

#Preview {
    CardView(allergies: [.beef, .chicken], currentPhase: .follicularPhase)
        .modelContainer(for: Food.self, inMemory: true)
}
