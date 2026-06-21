//
//  RecipeService.swift
//  quickfood
//

import Foundation

struct Recipe: Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let cookingTime: Int?
    let servings: Int?
    let ingredients: [RecipeIngredient]
    let steps: [RecipeStep]
    let thumbnailURL: URL?
}

struct RecipeIngredient: Identifiable, Equatable {
    let id: String
    let name: String
    let quantity: String
}

struct RecipeStep: Identifiable, Equatable {
    let id: String
    let number: Int
    let instruction: String
}

enum RecipeServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case recipeNotFound

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Recipe API URL is invalid."
        case .invalidResponse:
            return "Recipe API returned an invalid response."
        case .recipeNotFound:
            return "Recipe for this food was not found."
        }
    }
}

struct RecipeService {
    private let baseURL = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php")

    func fetchRecipe(for food: Food) async throws -> Recipe {
        guard var components = baseURL.flatMap({ URLComponents(url: $0, resolvingAgainstBaseURL: false) }) else {
            throw RecipeServiceError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "s", value: food.name)
        ]

        guard let url = components.url else {
            throw RecipeServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw RecipeServiceError.invalidResponse
        }

        let apiResponse = try JSONDecoder().decode(MealSearchResponse.self, from: data)

        guard let meal = apiResponse.meals?.first else {
            throw RecipeServiceError.recipeNotFound
        }

        return meal.recipe
    }
}

private struct MealSearchResponse: Decodable {
    let meals: [MealRecipe]?
}

private struct MealRecipe: Decodable {
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strArea: String?
    let strInstructions: String
    let strMealThumb: String?
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?

    var recipe: Recipe {
        Recipe(
            id: idMeal,
            name: strMeal,
            description: description,
            cookingTime: nil,
            servings: nil,
            ingredients: ingredients,
            steps: steps,
            thumbnailURL: strMealThumb.flatMap(URL.init(string:))
        )
    }

    private var description: String {
        [strCategory, strArea]
            .compactMap { clean($0) }
            .joined(separator: " • ")
    }

    private var ingredients: [RecipeIngredient] {
        let ingredientNames = [
            strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
            strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
            strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15,
            strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        ]
        let measures = [
            strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
            strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
            strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15,
            strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
        ]

        return ingredientNames.enumerated().compactMap { index, ingredientName in
            guard let name = clean(ingredientName) else { return nil }
            let quantity = clean(measures[index]) ?? ""

            return RecipeIngredient(
                id: "\(idMeal)-ingredient-\(index + 1)",
                name: name,
                quantity: quantity
            )
        }
    }

    private var steps: [RecipeStep] {
        strInstructions
            .split(whereSeparator: \.isNewline)
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .enumerated()
            .map { index, instruction in
                RecipeStep(
                    id: "\(idMeal)-step-\(index + 1)",
                    number: index + 1,
                    instruction: instruction
                )
            }
    }

    private func clean(_ value: String?) -> String? {
        guard let cleaned = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !cleaned.isEmpty else {
            return nil
        }

        return cleaned
    }
}
