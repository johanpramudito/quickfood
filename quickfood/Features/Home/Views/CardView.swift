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
    @State private var selectedRecipe: Recipe?
    @State private var isLoadingRecipe = false
    @State private var recipeErrorMessage: String?

    private let recipeService = RecipeService()
    let currentPhase: CyclePhase?  // ← add this

    var body: some View {
        VStack(alignment: .leading, spacing: -3) {
            Text("We Recommend You to Eat")
                .padding(.leading, 16)
                .font(.body.bold())

            ZStack {
                let visibleCards = Array(viewModel.visibleCards)
                ForEach(Array(visibleCards.enumerated()).reversed(), id: \.element.persistentModelID) { item in
                    FoodCard(
                        foodsData: item.element,
                        onSwiped: onSwiped,
                        onSelected: fetchRecipe
                    )
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
        .overlay {
            if isLoadingRecipe {
                ProgressView("Loading recipe...")
                    .padding(20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeSheetView(recipe: recipe)
        }
        .alert("Recipe", isPresented: recipeErrorIsPresented) {
            Button("OK", role: .cancel) { }
        } message: {
            if let recipeErrorMessage {
                Text(recipeErrorMessage)
            }
        }
    }

    private var recipeErrorIsPresented: Binding<Bool> {
        Binding(
            get: { recipeErrorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    recipeErrorMessage = nil
                }
            }
        )
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

    private func fetchRecipe(for food: Food) {
        guard !isLoadingRecipe else { return }

        isLoadingRecipe = true
        recipeErrorMessage = nil

        Task {
            do {
                selectedRecipe = try await recipeService.fetchRecipe(for: food)
            } catch {
                recipeErrorMessage = error.localizedDescription
            }

            isLoadingRecipe = false
        }
    }
}

private struct RecipeSheetView: View {
    let recipe: Recipe

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let thumbnailURL = recipe.thumbnailURL {
                        AsyncImage(url: thumbnailURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure, .empty:
                                Color.primaryYellow.opacity(0.4)
                            @unknown default:
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }

                    Text(recipe.name)
                        .font(.title2.bold())

                    if !recipe.description.isEmpty {
                        Text(recipe.description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 12) {
                        if let cookingTime = recipe.cookingTime {
                            Label("\(cookingTime) min", systemImage: "clock")
                        }

                        if let servings = recipe.servings {
                            Label("\(servings) servings", systemImage: "person.2")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    if !recipe.ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients")
                                .font(.headline)

                            ForEach(recipe.ingredients) { ingredient in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                    Text(ingredient.quantity.isEmpty ? ingredient.name : "\(ingredient.quantity) \(ingredient.name)")
                                }
                                .font(.body)
                            }
                        }
                    }

                    if !recipe.steps.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Steps")
                                .font(.headline)

                            ForEach(recipe.steps) { step in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("\(step.number).")
                                        .fontWeight(.semibold)
                                    Text(step.instruction)
                                }
                                .font(.body)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("Recipe")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CardView(allergies: [.beef, .chicken], currentPhase: .follicularPhase)
        .modelContainer(for: Food.self, inMemory: true)
}
