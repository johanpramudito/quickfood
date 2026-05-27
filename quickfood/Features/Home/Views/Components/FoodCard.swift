//
//  FoodCard.swift
//  quickfood
//
//  Created by Muhammad Najmi Rahmani  on 22/05/26.
//

import SwiftUI

struct FoodCard: View {
    @StateObject private var viewModel: CardViewModel
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    let SUPABASE_URL = "https://vlusefqntgrzetlqvulu.supabase.co/storage/v1/object/public/FoodCycle"

    private let onSwiped: () -> Void
    private let onSelected: (Food) -> Void

    init(
        foodsData: Food,
        onSwiped: @escaping () -> Void = {},
        onSelected: @escaping (Food) -> Void = { _ in }
    ) {
        _viewModel = StateObject(wrappedValue: CardViewModel(food: foodsData))
        self.onSwiped = onSwiped
        self.onSelected = onSelected
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: "\(SUPABASE_URL)/\(viewModel.food.image).jpg")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure, .empty:
                    Color.primaryYellow.opacity(0.4)
                @unknown default:
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: 362, height: 460)
            .clipped()

            AsyncImage(url: URL(string: "\(SUPABASE_URL)/\(viewModel.food.image).jpg")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure, .empty:
                    Color.primaryYellow.opacity(0.4)
                @unknown default:
                    Color.gray.opacity(0.3)
                }
            }
            .accessibilityLabel("\(viewModel.food.name) photo")
            .accessibilityHint("Swipe left or right to skip")
            .frame(width: 362, height: 460)
            .blur(radius: 16)
            .clipped()
            .mask(
                VStack(spacing: 0) {
                    Spacer()
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black, location: 0.35),
                            .init(color: .black, location: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 230)
                }
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("\(viewModel.food.name)")
                    .foregroundStyle(Color.white)
                    .font(.title.bold())
                
                HStack(spacing: 8) {
                    ForEach(Array(viewModel.food.nutrition.prefix(3)), id: \.self) { tag in
                        HStack(spacing: 4) {
                            Text("\(tag)")
                                .foregroundStyle(Color.primary)
                        }
                        .frame(width: 102, height: 31)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(20)
                    }
                }
                
                Divider()
                    .overlay(Color.white.opacity(0.4))
                
                Text("\(viewModel.food.notes)")
                    .font(.callout)
                    .foregroundStyle(Color.white)
            }
            .padding(16)
        }
        .frame(width: 362, height: 460, alignment: .bottomLeading)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(16)
        .offset(x: viewModel.xOffset, y: 0)
        .rotationEffect(.degrees(viewModel.rotationDegrees))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    viewModel.updateDragOffset(gesture.translation)
                }
                .onEnded { _ in
                    handleSwipeEnded()
                }
            
        )
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    onSelected(viewModel.food)
                }
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(viewModel.food.name). \(viewModel.food.notes)")
        .accessibilityHint("Swipe left or right to skip, or use the actions below")
        .accessibilityAction(named: "Skip this food") {
            performAccessibilitySwipe(to: .right)
        }
        .accessibilityAction(named: "Save this food") {
            performAccessibilitySwipe(to: .left)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(362 / 460, contentMode: .fit)
    }

    private func performAccessibilitySwipe(to direction: SwipeDirection) {
        if reduceMotion {
            viewModel.moveOffscreen(to: direction)
            finishSwipe()
        } else {
            withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
                viewModel.moveOffscreen(to: direction)
            }
            finishSwipe()
        }
    }
    
    private func handleSwipeEnded() {
        guard let direction = viewModel.swipeDirection() else {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) {
                viewModel.resetOffset()
            }
            return
        }

        withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
            viewModel.moveOffscreen(to: direction)
        }
        finishSwipe()
    }

    private func finishSwipe() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            viewModel.resetOffset()
            onSwiped()
        }
    }
}

extension View {
    func stacked(at position: Int) -> some View {
        let offset = Double(position)
        let cardscale = 1 - (offset * 0.05)
            
        return self
            .scaleEffect(cardscale)
            .offset(x: 10 * offset, y: 15 * offset)
        
    }
}

#Preview {
    FoodCard(
        foodsData: Food(
            name: "Sayur Asem",
            category: "Soup",
            tags: ["Fresh", "Light"],
            nutrition: ["Vitamin C"],
            cyclePhase: "Menstrual",
            notes: "Sayur asem is a traditional Indonesian vegetable soup dish with a clear or slightly cloudy broth with a fresh, savory, and slightly sweet tamarind flavor.",
            image: "sigma"
        )
    )
}
