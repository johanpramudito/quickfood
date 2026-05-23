//
//  FoodCard.swift
//  quickfood
//
//  Created by Muhammad Najmi Rahmani  on 22/05/26.
//

import SwiftUI

struct FoodCard: View {
    @StateObject private var viewModel: CardViewModel

    private let onSwiped: () -> Void

    init(foodsData: Food, onSwiped: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: CardViewModel(food: foodsData))
        self.onSwiped = onSwiped
    }

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(viewModel.food.name)")
                        .foregroundStyle(Color.white)
                        .font(.title.bold())
                    
                    HStack(spacing: 8) {
                        ForEach(viewModel.food.tags, id: \.self) { tag in
                            HStack(spacing: 4) {
                                Text("\(tag)")
                                    .foregroundStyle(Color.black)
                            }
                            .frame(width: 102, height: 31)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(20)
                        }
                    }
                    
                    Divider()
                    
                    Text("\(viewModel.food.notes)")
                        .font(.callout)
                        .foregroundStyle(Color.white)
                }
                .padding(16)
                .padding(.top, 252)
            }
            .frame(width: 362, height: 460, alignment: .leading)
            .background(
                Image("Sayurasem")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            )
            .cornerRadius(24)
            .padding(16)
//            .padding(.top, 252)
            //        .blur(radius: 0.1)
        }
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
            cyclePhase: "Menstrual",
            notes: "A warm vegetable soup with a bright, tangy broth."
        )
    )
}
