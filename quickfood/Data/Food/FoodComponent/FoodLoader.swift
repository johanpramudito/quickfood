//
//  FoodLoader.swift
//  quickfood
//
//  Created by Bintang Marsyuma Rakhasunu on 22/05/26.
//

import Foundation
import SwiftData

struct FoodSeed: Decodable {
    let name: String
    let category: String
    let tags: [String]
    let nutrition: [String]
    let cyclePhase: String
    let notes: String
    let image: String
}

func seedFoodsIfNeeded(modelContext: ModelContext) {
    let descriptor = FetchDescriptor<Food>()

    do {
        let existingFoods = try modelContext.fetch(descriptor)

        guard existingFoods.isEmpty else {
            return
        }

        guard let url = Bundle.main.url(forResource: "foods", withExtension: "json") else {
            print("foods.json not found")
            return
        }

        let data = try Data(contentsOf: url)
        let seeds = try JSONDecoder().decode([FoodSeed].self, from: data)

        for seed in seeds {
            let food = Food(
                name: seed.name,
                category: seed.category,
                tags: seed.tags,
                nutrition: seed.nutrition,
                cyclePhase: seed.cyclePhase,
                notes: seed.notes,
                image: seed.image
            )

            modelContext.insert(food)
        }

        try modelContext.save()
        print("Successfully seeded foods")
    } catch {
        print("Failed to seed foods: \(error)")
    }
}
