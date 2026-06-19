//
//  CardViewModel.swift
//  quickfood
//
//  Created by Muhammad Najmi Rahmani on 22/05/26.
//

import Combine
import SwiftUI

@MainActor
final class CardViewModel: ObservableObject {
    @Published private(set) var offset: CGSize = .zero

    let food: Food

    var xOffset: CGFloat {
        offset.width
    }

    var rotationDegrees: Double {
        Double(offset.width / 30)
    }

    init(food: Food) {
        self.food = food
    }

    func updateDragOffset(_ translation: CGSize) {
        offset = translation
    }

    func swipeDirection() -> SwipeDirection? {
        if offset.width > 50 {
            return .right
        }

        if offset.width < -50 {
            return .left
        }

        return nil
    }

    func moveOffscreen(to direction: SwipeDirection) {
        offset.width = direction.offscreenXOffset
    }

    func resetOffset() {
        offset = .zero
    }
}

@MainActor
final class CardStackViewModel: ObservableObject {
    @Published private(set) var foodCards: [Food] = []

    var visibleCards: ArraySlice<Food> {
        foodCards.prefix(3)
    }

    func loadFoods(_ foods: [Food]) {
        foodCards = foods
    }

    func loadFoodsIfEmpty(_ foods: [Food]) {
        guard foodCards.isEmpty else { return }
        foodCards = foods
    }

    func moveTopCardToBack() {
        guard !foodCards.isEmpty else { return }
        let firstFood = foodCards.removeFirst()
        foodCards.append(firstFood)
    }
}

enum SwipeDirection {
    case left
    case right

    var offscreenXOffset: CGFloat {
        switch self {
        case .left:
            -600
        case .right:
            500
        }
    }
}

// test
