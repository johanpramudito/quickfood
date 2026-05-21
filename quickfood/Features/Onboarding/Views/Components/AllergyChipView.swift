//
//  AllergyChipView.swift
//  quickfood
//
//  Created by Johan on 21/05/26.
//

import SwiftUI

struct AllergyChipView: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8){
                Text(icon)
                    .font(.title2)
                Text(title)
                    .fontWeight(.semibold)
                    .font(.headline)
            }
            .padding()
            .foregroundStyle(isSelected ? .primaryRed : .white)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(isSelected ? .white : .primaryRed)
                    .shadow(color: .black.opacity(0.18), radius: 6, x: 3, y: 0)
            )
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        AllergyChipView(
            title: "Seafood",
            icon: "🦐",
            isSelected: true
        ) {
            print("Seafood tapped")
        }

        AllergyChipView(
            title: "Beef",
            icon: "🥩",
            isSelected: false
        ) {
            print("Beef tapped")
        }
    }
    .padding()}
