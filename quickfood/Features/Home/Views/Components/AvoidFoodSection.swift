//
//  AvoidFoodSection.swift
//  quickfood
//
//  Created by Muhammad Ridwan Novriansyah on 26/05/26.
//

import SwiftUI

struct AvoidFoodsSection: View {
    let allergies: [UserAllergy]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("Avoid Foods")
                    .font(.title2)
                    .fontWeight(.bold)

                NavigationLink {
                    AvoidFoodView(isEditing: true)
                } label: {
                    Image(systemName: "pencil.line")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color.primary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Edit avoid foods")
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(allergies, id: \.self) { allergy in
                        HStack(spacing: 8) {
                            Text(allergy.icon)
                                .font(.title2)

                            Text(allergy.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(.primaryYellow)
                        .clipShape(Capsule())

                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview {
    AvoidFoodsSection(allergies: [.seafood, .offal, .egg])
        .background(.primaryBackground)
}
