//
//  AvoidFoodView.swift
//  quickfood
//
//  Created by Johan on 21/05/26.
//

import SwiftUI

struct AvoidFoodView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("selectedAllergies") private var selectedAllergyRawValues = ""
    @State private var navigateToHealthPermission = false

    private let isEditing: Bool

    @State private var nama:String = ""
    @State private var selectedAllergies: Set<UserAllergy> = []

    init(isEditing: Bool = false) {
        self.isEditing = isEditing
    }
    
    private func toggleAllergy(_ allergy: UserAllergy) {
        if selectedAllergies.contains(allergy) {
            selectedAllergies.remove(allergy)
        } else {
            selectedAllergies.insert(allergy)
        }

        saveSelectedAllergies()
    }

    private func loadSelectedAllergies() {
        selectedAllergies = Set(
            selectedAllergyRawValues
                .split(separator: ",")
                .compactMap { UserAllergy(rawValue: String($0)) }
        )
    }

    private func saveSelectedAllergies() {
        selectedAllergyRawValues = selectedAllergies
            .map(\.rawValue)
            .sorted()
            .joined(separator: ",")
    }
    
    private let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 8)
    ]
    
    struct WrappingHStack: Layout {
        var spacing: CGFloat = 8
        var lineSpacing: CGFloat = 8

        func sizeThatFits(
            proposal: ProposedViewSize,
            subviews: Subviews,
            cache: inout ()
        ) -> CGSize {
            let maxWidth = proposal.width ?? .infinity
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            var maxLineWidth: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if currentX > 0 && currentX + size.width > maxWidth {
                    maxLineWidth = max(maxLineWidth, currentX - spacing)
                    currentX = 0
                    currentY += lineHeight + lineSpacing
                    lineHeight = 0
                }

                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }

            maxLineWidth = max(maxLineWidth, currentX - spacing)

            return CGSize(
                width: min(maxLineWidth, maxWidth),
                height: currentY + lineHeight
            )
        }

        func placeSubviews(
            in bounds: CGRect,
            proposal: ProposedViewSize,
            subviews: Subviews,
            cache: inout ()
        ) {
            var currentX = bounds.minX
            var currentY = bounds.minY
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if currentX > bounds.minX && currentX + size.width > bounds.maxX {
                    currentX = bounds.minX
                    currentY += lineHeight + lineSpacing
                    lineHeight = 0
                }

                subview.place(
                    at: CGPoint(x: currentX, y: currentY),
                    proposal: ProposedViewSize(size)
                )

                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
        }
    }


    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("What food would you rather avoid?")
                .multilineTextAlignment(.leading)
                .font(.largeTitle).bold()
                .fontDesign(.rounded)
            Text("Select any ingredients or food categories you prefer not to include in your personalized meal plans.")
                .multilineTextAlignment(.leading)
                .font(.title2)
                .fontWeight(.thin)
                .fontDesign(.rounded)
            WrappingHStack(spacing: 8, lineSpacing: 8) {
                ForEach(UserAllergy.allCases, id: \.self) { allergy in
                    AllergyChipView(
                        title: allergy.title,
                        icon: allergy.icon,
                        isSelected: selectedAllergies.contains(allergy)
                    ) {
                        toggleAllergy(allergy)
                    }
                }
            }

            Spacer()
            Button {
                saveSelectedAllergies()

                if isEditing {
                    dismiss()
                } else {
                    navigateToHealthPermission = true
                }
            } label: {
                Text(isEditing ? "Done" : "Next")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .foregroundStyle(.white)
            .glassEffect(.regular.tint(.primaryYellow).interactive())
            .navigationDestination(isPresented: $navigateToHealthPermission) {
                HealthPermissionView()
            }
//            .navigationBarBackButtonHidden(true)

        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .background(.primaryBackground)
        .onAppear {
            loadSelectedAllergies()
        }
    }
}



#Preview {
    AvoidFoodView()
}
